# Error Handler Reference

## Overview

This project is a simple and clear reference for error handling in Flutter. It demonstrates how to build an organized error handling system that can be used in any project.

## Why Do We Need an Error Handling System?

### Problems without an error handling system:

- ❌ App crashes when an error occurs
- ❌ Unclear error messages for users
- ❌ Difficulty in tracking and solving problems
- ❌ Poor user experience

### Benefits with an error handling system:

- ✅ App continues to work
- ✅ Clear and helpful error messages
- ✅ Easy problem tracking and solving
- ✅ Excellent user experience

## System Architecture

### 1. ErrorModel - Data Model

```dart
class ErrorModel {
  final String message;           // Error message
  final String? status;          // HTTP status
  final String? code;            // Error code
  final Map<String, List<String>>? validationErrors; // Validation errors
  final Map<String, dynamic>? additionalData;        // Additional data
}
```

### 2. Exceptions - Exception Classes

```dart
// Base exception
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
}

// Exception types
class ServerException extends AppException    // Server errors
class NetworkException extends AppException   // Network errors
class CacheException extends AppException     // Storage errors
class ValidationException extends AppException // Validation errors
```

### 3. Failures - Failure Classes

```dart
// Base failure
abstract class Failure {
  final String message;
  final String? code;
  final dynamic originalError;
}

// Failure types
class ServerFailure extends Failure
class NetworkFailure extends Failure
class CacheFailure extends Failure
class ValidationFailure extends Failure
class UnknownFailure extends Failure
```

### 4. ExceptionHandler - Error Handler

```dart
class ExceptionHandler {
  // Convert DioException to AppException
  static AppException handleDioException(DioException e);

  // Convert AppException to Failure
  static Failure exceptionToFailure(AppException exception);
}
```

## How to Use

### Basic Usage

```dart
import 'package:error_handler/error.dart';

try {
  final response = await dio.get('/api/users');
  // Handle successful data
} on DioException catch (e) {
  // Convert DioException to AppException
  final exception = ExceptionHandler.handleDioException(e);

  // Convert AppException to Failure
  final failure = ExceptionHandler.exceptionToFailure(exception);

  // Show error message to user
  showErrorDialog(failure.userMessage);
}
```

## Supported Error Types

### 1. NetworkException - Network Errors

- Internet disconnection
- Connection timeout
- SSL certificate error
- Request cancellation

### 2. ServerException - Server Errors

- 400: Bad Request
- 401: Unauthorized
- 403: Forbidden
- 404: Not Found
- 422: Validation Error
- 500: Internal Server Error
- 502: Bad Gateway
- 503: Service Unavailable

### 3. ValidationException - Validation Errors

- Missing required fields
- Incorrect data format
- Data validation constraints

### 4. CacheException - Storage Errors

- Failed to save data
- Failed to read data
- Storage space full

## Best Practices

### 1. Always Use try-catch

```dart
// ✅ Correct
try {
  final response = await dio.get('/api/users');
} on DioException catch (e) {
  // Handle error
}

// ❌ Wrong
final response = await dio.get('/api/users'); // App may crash
```

### 2. Clear Error Messages

```dart
// ✅ Correct
showErrorDialog(failure.userMessage);

// ❌ Wrong
showErrorDialog('Error occurred'); // Unclear message
```

### 3. Check Error Type

```dart
// ✅ Correct
if (failure.isNetworkError) {
  // Retry
} else if (failure.isServerError) {
  // Show server error message
}

// ❌ Wrong
// Handle all errors the same way
```

## Running the Project

```bash
flutter pub get
flutter run
```

## Project Structure

```
lib/
├── main.dart                    # Main app
├── views/                       # Views
│   └── error_explanation_view.dart
├── widgets/                     # Widgets
│   ├── section_header.dart
│   ├── info_section.dart
│   ├── error_test_section.dart
│   ├── error_types_section.dart
│   ├── best_practices_section.dart
│   ├── usage_examples_section.dart
│   └── comparison_section.dart
├── data/                        # Data
│   └── section_content.dart
├── error/                       # Error handling system
│   ├── error.dart              # Main export file
│   ├── error_model.dart        # Error data model
│   ├── exceptions.dart         # Exceptions
│   ├── failures.dart          # Failures
│   └── README.md              # Detailed documentation
└── examples/                    # Examples
    ├── usage_example.dart
    └── README.md
```

## Features

### ✅ Organization

- Separated components into individual widgets
- Separated data into individual files
- Separated screens into individual views

### ✅ Reusability

- Each widget can be used in other places
- Separate content that can be easily modified
- Customizable components

### ✅ Maintenance

- Organized and clear code
- Easy to add new components
- Easy to modify content

### ✅ Performance

- Load components only when needed
- Separate display logic from data
- Optimized and organized code

## How to Use

### Adding a New Component

1. Create a new file in the `widgets/` folder
2. Follow the same pattern as existing components
3. Import the component in the required screen

### Modifying Content

1. Edit the `data/section_content.dart` file
2. Use the variables in components

### Adding a New Screen

1. Create a new file in the `views/` folder
2. Use existing components
3. Add the screen to the main app

## Examples

### Using a Component

```dart
import '../widgets/info_section.dart';

Widget build(BuildContext context) {
  return InfoSection(
    title: 'Section Title',
    content: 'Section Content',
    icon: Icons.info,
  );
}
```

### Using Content

```dart
import '../data/section_content.dart';

String content = SectionContent.introductionContent;
```

## Summary

This error handling system provides:

- **Clear organization** for errors
- **Easy usage** in the app
- **Flexibility** in adding new error types
- **Clear messages** for users
- **Easy tracking** of problems

Use this system as a foundation to build a strong error handling system in your projects.
