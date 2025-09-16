/// Model class for API error responses
class ErrorModel {
  final String message;
  final String? status;
  final String? code;
  final Map<String, List<String>>? validationErrors;
  final Map<String, dynamic>? additionalData;

  const ErrorModel({
    required this.message,
    this.status,
    this.code,
    this.validationErrors,
    this.additionalData,
  });

  /// Create ErrorModel from JSON response
  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>>? validationErrors;

    // Parse validation errors
    if (json['errors'] != null) {
      validationErrors = {};
      final errors = json['errors'] as Map<String, dynamic>;
      errors.forEach((key, value) {
        if (value is List) {
          validationErrors![key] = List<String>.from(value);
        } else if (value is String) {
          validationErrors![key] = [value];
        }
      });
    }

    return ErrorModel(
      message: json['message'] ?? json['error'] ?? 'حدث خطأ غير معروف',
      status: json['status']?.toString() ?? json['key']?.toString(),
      code: json['code']?.toString(),
      validationErrors: validationErrors,
      additionalData: json['data'] as Map<String, dynamic>?,
    );
  }

  /// Convert ErrorModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'code': code,
      'errors': validationErrors,
      'data': additionalData,
    };
  }

  /// Get the first validation error
  String? getFirstValidationError() {
    if (validationErrors != null && validationErrors!.isNotEmpty) {
      final firstField = validationErrors!.keys.first;
      final errors = validationErrors![firstField];
      if (errors != null && errors.isNotEmpty) {
        return errors.first;
      }
    }
    return null;
  }

  /// Get all validation errors as a single string
  String getAllValidationErrors() {
    if (validationErrors == null || validationErrors!.isEmpty) {
      return message;
    }

    final List<String> allErrors = [];
    validationErrors!.forEach((field, errors) {
      allErrors.addAll(errors);
    });

    return allErrors.join('\n');
  }

  /// Check if there are validation errors
  bool get hasValidationErrors =>
      validationErrors != null && validationErrors!.isNotEmpty;

  /// Get validation errors for a specific field
  List<String>? getFieldErrors(String fieldName) {
    return validationErrors?[fieldName];
  }

  /// Get user-friendly error message
  String get userMessage {
    if (hasValidationErrors) {
      return getFirstValidationError() ?? message;
    }
    return message;
  }

  /// Check if error is a specific type
  bool isErrorType(String errorType) {
    return code == errorType || status == errorType;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ErrorModel &&
        other.message == message &&
        other.status == status &&
        other.code == code;
  }

  @override
  int get hashCode => message.hashCode ^ status.hashCode ^ code.hashCode;

  @override
  String toString() =>
      'ErrorModel(message: $message, status: $status, code: $code)';
}
