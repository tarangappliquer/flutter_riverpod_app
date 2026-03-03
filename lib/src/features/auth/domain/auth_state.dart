import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';
part 'auth_state.g.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    User? user,
    String? accessToken,
    String? refreshToken,
    @Default(false) bool isLoading,
  }) = _AuthState;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}

@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String username,
    required String email,
    String? firstName,
    String? lastName,
    String? image,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
