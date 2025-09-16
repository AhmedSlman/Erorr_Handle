/// Base failure class for all application failures
abstract class Failure {
  final String message;
  final String? code;
  final dynamic originalError;

  const Failure({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message && other.code == code;
  }

  @override
  int get hashCode => message.hashCode ^ code.hashCode;

  @override
  String toString() => 'Failure: $message';
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'حدث خطأ في الخادم',
    super.code = 'SERVER_ERROR',
    super.originalError,
  });

  @override
  String toString() => 'ServerFailure: $message';
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'حدث خطأ في التخزين المؤقت',
    super.code = 'CACHE_ERROR',
    super.originalError,
  });

  @override
  String toString() => 'CacheFailure: $message';
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'حدث خطأ في الاتصال بالإنترنت',
    super.code = 'NETWORK_ERROR',
    super.originalError,
  });

  @override
  String toString() => 'NetworkFailure: $message';
}

/// Validation-related failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    super.originalError,
  });

  @override
  String toString() => 'ValidationFailure: $message';
}

/// Unknown failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'حدث خطأ غير معروف',
    super.code = 'UNKNOWN_ERROR',
    super.originalError,
  });

  @override
  String toString() => 'UnknownFailure: $message';
}

/// No internet connection failure
class NoInternetFailure extends Failure {
  const NoInternetFailure({
    super.message = 'لا يوجد اتصال بالانترنت',
    super.code = 'NO_INTERNET',
    super.originalError,
  });

  @override
  String toString() => 'NoInternetFailure: $message';
}

/// No connection failure
class NoConnectionFailure extends Failure {
  const NoConnectionFailure({
    super.message = 'لا يوجد اتصال بالانترنت',
    super.code = 'NO_CONNECTION',
    super.originalError,
  });

  @override
  String toString() => 'NoConnectionFailure: $message';
}

/// No data available failure
class NoDataFailure extends Failure {
  const NoDataFailure({
    super.message = 'لا يوجد بيانات',
    super.code = 'NO_DATA',
    super.originalError,
  });

  @override
  String toString() => 'NoDataFailure: $message';
}

/// Authentication failure
class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'فشل في المصادقة',
    super.code = 'AUTH_ERROR',
    super.originalError,
  });

  @override
  String toString() => 'AuthFailure: $message';
}

/// Permission failure
class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'ليس لديك صلاحية للوصول',
    super.code = 'PERMISSION_ERROR',
    super.originalError,
  });

  @override
  String toString() => 'PermissionFailure: $message';
}

/// Timeout failure
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'انتهت مهلة الاتصال',
    super.code = 'TIMEOUT_ERROR',
    super.originalError,
  });

  @override
  String toString() => 'TimeoutFailure: $message';
}

/// Extension methods for Failure
extension FailureExtensions on Failure {
  /// Check if failure is network related
  bool get isNetworkError =>
      this is NetworkFailure ||
      this is NoInternetFailure ||
      this is NoConnectionFailure ||
      this is TimeoutFailure;

  /// Check if failure is server related
  bool get isServerError => this is ServerFailure;

  /// Check if failure is cache related
  bool get isCacheError => this is CacheFailure;

  /// Check if failure is validation related
  bool get isValidationError => this is ValidationFailure;

  /// Check if failure is authentication related
  bool get isAuthError => this is AuthFailure || this is PermissionFailure;

  /// Get user-friendly error message
  String get userMessage {
    if (isNetworkError) {
      return 'تحقق من اتصالك بالإنترنت';
    } else if (isServerError) {
      return 'حدث خطأ في الخادم، حاول مرة أخرى';
    } else if (isAuthError) {
      return 'يرجى تسجيل الدخول مرة أخرى';
    } else {
      return message;
    }
  }
}
