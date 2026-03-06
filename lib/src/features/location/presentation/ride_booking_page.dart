import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mappls_gl/mappls_gl.dart';
import 'location_notifier.dart';
import '../../ride/presentation/ride_notifier.dart';

class RideBookingPage extends HookConsumerWidget {
  const RideBookingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(locationProvider);
    final rideState = ref.watch(rideControllerProvider);
    final mapController = useRef<MapplsMapController?>(null);

    // Sync Map UI with RideState
    useEffect(() {
      final controller = mapController.value;
      if (controller == null) return;

      void updateMap() async {
        await controller.clearSymbols();
        await controller.clearLines();

        if (rideState.pickup != null) {
          await controller.addSymbol(
            SymbolOptions(
              geometry: rideState.pickup!,
              iconImage: "origin_marker",
            ),
          );
        }
        if (rideState.destination != null) {
          await controller.addSymbol(
            SymbolOptions(
              geometry: rideState.destination!,
              iconImage: "destination_marker",
            ),
          );
        }
        if (rideState.polyline.isNotEmpty) {
          await controller.addLine(
            LineOptions(
              geometry: rideState.polyline,
              lineColor: "#3bb2d0",
              lineWidth: 5,
            ),
          );
          _fitRoute(controller, rideState.polyline);
        }
      }

      updateMap();
      return null;
    }, [rideState]);

    return Scaffold(
      body: locationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => _ErrorView(error: err),
        data: (position) {
          // Initialize pickup with current location once
          if (rideState.pickup == null && position != null) {
            Future.microtask(
              () => ref
                  .read(rideControllerProvider.notifier)
                  .setPickup(LatLng(position.latitude, position.longitude)),
            );
          }

          return Stack(
            children: [
              MapplsMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    position?.latitude ?? 28.6,
                    position?.longitude ?? 77.2,
                  ),
                  zoom: 14.0,
                ),
                onMapCreated: (c) => mapController.value = c,
                myLocationEnabled: true,
                myLocationTrackingMode: MyLocationTrackingMode.trackingGps,
              ),
              const _RideSearchSheet(),
            ],
          );
        },
      ),
    );
  }

  void _fitRoute(MapplsMapController controller, List<LatLng> points) {
    if (points.isEmpty) return;
    double minLat = points
        .map((p) => p.latitude)
        .reduce((a, b) => a < b ? a : b);
    double maxLat = points
        .map((p) => p.latitude)
        .reduce((a, b) => a > b ? a : b);
    double minLng = points
        .map((p) => p.longitude)
        .reduce((a, b) => a < b ? a : b);
    double maxLng = points
        .map((p) => p.longitude)
        .reduce((a, b) => a > b ? a : b);

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        left: 50,
        right: 50,
        top: 100,
        bottom: 350,
      ),
    );
  }
}

class _RideSearchSheet extends ConsumerWidget {
  const _RideSearchSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideState = ref.watch(rideControllerProvider);
    final userPos = ref.watch(locationProvider).value;
    final bias = LatLng(userPos?.latitude ?? 28.6, userPos?.longitude ?? 77.2);

    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: ListView(
          controller: scrollController,
          children: [
            _buildHandle(),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Column(
                  children: [
                    _SearchTile(
                      label: rideState.pickupName ?? "Select Pickup",
                      icon: Icons.circle_outlined,
                      color: Colors.green,
                      onTap: () => ref
                          .read(rideControllerProvider.notifier)
                          .searchLocation(true, bias),
                    ),
                    _SearchTile(
                      label: rideState.destinationName ?? "Where to?",
                      icon: Icons.location_on,
                      color: Colors.red,
                      onTap: () => ref
                          .read(rideControllerProvider.notifier)
                          .searchLocation(false, bias),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: FloatingActionButton.small(
                    onPressed: () => ref
                        .read(rideControllerProvider.notifier)
                        .swapLocations(),
                    child: const Icon(Icons.swap_vert),
                  ),
                ),
              ],
            ),
            const Divider(),
            _rideOption("Mappls Mini", "₹150", Icons.directions_car),
            _rideOption("Mappls Sedan", "₹220", Icons.local_taxi),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: rideState.polyline.isEmpty ? null : () {},
                child: const Text("CONFIRM BOOKING"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() => Center(
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 4,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );

  Widget _rideOption(String name, String price, IconData icon) => ListTile(
    leading: Icon(icon),
    title: Text(name),
    trailing: Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}

class _SearchTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SearchTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: onTap,
    );
  }
}

class _ErrorView extends ConsumerWidget {
  final Object error;
  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => ref.read(locationProvider.notifier).getLocation(),
      child: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_off, size: 80, color: Colors.grey),
                Text('$error', textAlign: TextAlign.center),
                const Text("Pull down to retry"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
