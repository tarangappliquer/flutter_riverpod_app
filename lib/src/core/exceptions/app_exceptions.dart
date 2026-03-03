import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => message;

  /// Helper to convert Dio errors into AppExceptions
  factory AppException.fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return AppException(
          'Connection timed out. Please check your internet.',
        );
      case DioExceptionType.badResponse:
        final data = error.response?.data;
        return AppException(data?['message'] ?? 'Server error occurred.');
      case DioExceptionType.cancel:
        return AppException('Request was cancelled.');
      default:
        return AppException('Something went wrong. Please try again.');
    }
  }
}
