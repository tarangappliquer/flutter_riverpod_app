import 'package:flutter/material.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:mappls_gl/mappls_gl.dart';
import 'package:mappls_place_widget/mappls_place_widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ride_notifier.g.dart';

class RideState {
  final LatLng? pickup;
  final LatLng? destination;
  final List<LatLng> polyline;
  final String? pickupName;
  final String? destinationName;

  RideState({
    this.pickup,
    this.destination,
    this.polyline = const [],
    this.pickupName,
    this.destinationName,
  });

  RideState copyWith({
    LatLng? pickup,
    LatLng? destination,
    List<LatLng>? polyline,
    String? pickupName,
    String? destinationName,
  }) {
    return RideState(
      pickup: pickup ?? this.pickup,
      destination: destination ?? this.destination,
      polyline: polyline ?? this.polyline,
      pickupName: pickupName ?? this.pickupName,
      destinationName: destinationName ?? this.destinationName,
    );
  }
}

@riverpod
class RideController extends _$RideController {
  @override
  RideState build() => RideState(pickupName: "Current Location");

  void setPickup(LatLng point, [String name = "Current Location"]) {
    state = state.copyWith(pickup: point, pickupName: name);
    if (state.destination != null) _fetchRoute();
  }

  void swapLocations() {
    final tempPoint = state.pickup;
    final tempName = state.pickupName;
    state = state.copyWith(
      pickup: state.destination,
      pickupName: state.destinationName,
      destination: tempPoint,
      destinationName: tempName,
    );
    if (state.pickup != null && state.destination != null) _fetchRoute();
  }

  Future<void> searchLocation(bool isPickup, LatLng bias) async {
    try {
      ELocation? selected = (await openPlaceAutocomplete(
        PlaceOptions(
          hint: isPickup ? "Search Pickup" : "Search Destination",
          location: bias,
        ),
      )).eLocation;

      if (selected?.latitude != null) {
        final point = LatLng(selected!.latitude!, selected.longitude!);
        final name =
            selected.placeName ?? selected.alternateName ?? "Selected Location";

        if (isPickup) {
          state = state.copyWith(pickup: point, pickupName: name);
        } else {
          state = state.copyWith(destination: point, destinationName: name);
        }
        _fetchRoute();
      }
    } catch (e) {
      debugPrint("Search error: $e");
    }
  }

  Future<void> _fetchRoute() async {
    if (state.pickup == null || state.destination == null) return;

    try {
      DirectionResponse? response = await MapplsDirection(
        origin: state.pickup,
        destination: state.destination,
      ).callDirection();

      if (response?.routes?.isNotEmpty ?? false) {
        final encoded = response!.routes![0].geometry;
        if (encoded != null) {
          final decoded = decodePolyline(encoded, accuracyExponent: 6);
          final path = decoded
              .map((c) => LatLng(c[0].toDouble(), c[1].toDouble()))
              .toList();
          state = state.copyWith(polyline: path);
        }
      }
    } catch (e) {
      debugPrint("Routing error: $e");
    }
  }
}
