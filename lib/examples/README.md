# أمثلة استخدام نظام معالجة الأخطاء

## نظرة عامة

هذا المجلد يحتوي على أمثلة عملية لاستخدام نظام معالجة الأخطاء في مشاريع Flutter الحقيقية.

## الملفات

- `usage_example.dart` - أمثلة شاملة لاستخدام النظام

## الأمثلة المتاحة

### 1. الاستخدام الأساسي

```dart
Future<void> basicUsageExample() async {
  try {
    final response = await dio.get('/api/users');
    print('تم جلب البيانات بنجاح: ${response.data}');
  } on DioException catch (e) {
    final exception = ExceptionHandler.handleDioException(e);
    final failure = ExceptionHandler.exceptionToFailure(exception);
    print('خطأ: ${failure.userMessage}');
  }
}
```

### 2. معالجة أخطاء في واجهة المستخدم

```dart
Future<void> uiErrorHandlingExample(BuildContext context) async {
  try {
    // إظهار مؤشر التحميل
    showDialog(context: context, ...);

    final response = await dio.get('/api/users');
    Navigator.of(context).pop(); // إخفاء مؤشر التحميل

  } on DioException catch (e) {
    Navigator.of(context).pop(); // إخفاء مؤشر التحميل

    final exception = ExceptionHandler.handleDioException(e);
    final failure = ExceptionHandler.exceptionToFailure(exception);

    // عرض رسالة الخطأ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(failure.userMessage)),
    );
  }
}
```

### 3. إعادة المحاولة للأخطاء الشبكية

```dart
Future<List<dynamic>> fetchUsersWithRetry() async {
  for (int attempt = 1; attempt <= 3; attempt++) {
    try {
      final response = await dio.get('/api/users');
      return response.data as List;
    } on DioException catch (e) {
      final exception = ExceptionHandler.handleDioException(e);
      final failure = ExceptionHandler.exceptionToFailure(exception);

      // إعادة المحاولة للأخطاء الشبكية فقط
      if (failure.isNetworkError && attempt < 3) {
        await Future.delayed(Duration(seconds: attempt));
        continue;
      }

      throw failure;
    }
  }
  throw const NetworkFailure();
}
```

### 4. معالجة أخطاء التحقق من البيانات

```dart
bool validateUserData(Map<String, dynamic> userData) {
  final errors = <String, List<String>>{};

  // التحقق من الاسم
  if (userData['name'] == null || userData['name'].toString().isEmpty) {
    errors['name'] = ['الاسم مطلوب'];
  }

  // التحقق من البريد الإلكتروني
  final email = userData['email']?.toString() ?? '';
  if (email.isEmpty) {
    errors['email'] = ['البريد الإلكتروني مطلوب'];
  } else if (!_isValidEmail(email)) {
    errors['email'] = ['البريد الإلكتروني غير صحيح'];
  }

  if (errors.isNotEmpty) {
    final errorModel = ErrorModel(
      message: 'خطأ في التحقق من البيانات',
      validationErrors: errors,
    );

    // طباعة الأخطاء
    errors.forEach((field, fieldErrors) {
      print('$field: ${fieldErrors.join(', ')}');
    });

    return false;
  }

  return true;
}
```

### 5. استخدام Result pattern

```dart
Future<Result<List<dynamic>, Failure>> fetchUsersResult() async {
  try {
    final response = await dio.get('/api/users');
    return Result.success(response.data as List);
  } on DioException catch (e) {
    final exception = ExceptionHandler.handleDioException(e);
    final failure = ExceptionHandler.exceptionToFailure(exception);
    return Result.failure(failure);
  }
}

// الاستخدام
fetchUsersResult()
  .onSuccess((users) => print('تم جلب ${users.length} مستخدم'))
  .onFailure((error) => print('خطأ: ${error.userMessage}'));
```

### 6. معالجة أخطاء متعددة الأنواع

```dart
Future<void> handleMultipleErrorTypes() async {
  try {
    final response = await dio.get('/api/users');
    print('تم جلب البيانات بنجاح');
  } on DioException catch (e) {
    final exception = ExceptionHandler.handleDioException(e);
    final failure = ExceptionHandler.exceptionToFailure(exception);

    // معالجة كل نوع خطأ بطريقة مختلفة
    if (failure.isNetworkError) {
      print('خطأ في الشبكة: ${failure.userMessage}');
    } else if (failure.isServerError) {
      print('خطأ في الخادم: ${failure.userMessage}');
    } else if (failure.isValidationError) {
      print('خطأ في التحقق: ${failure.userMessage}');
    } else {
      print('خطأ غير معروف: ${failure.userMessage}');
    }
  }
}
```

### 7. تسجيل الأخطاء

```dart
Future<void> logErrorsExample() async {
  try {
    final response = await dio.get('/api/users');
    print('تم جلب البيانات بنجاح');
  } on DioException catch (e) {
    // تسجيل الخطأ للمطورين
    print('=== خطأ API ===');
    print('النوع: ${e.type}');
    print('الرسالة: ${e.message}');
    print('الكود: ${e.response?.statusCode}');
    print('البيانات: ${e.response?.data}');
    print('===============');

    // معالجة الخطأ للمستخدم
    final exception = ExceptionHandler.handleDioException(e);
    final failure = ExceptionHandler.exceptionToFailure(exception);
    print('رسالة المستخدم: ${failure.userMessage}');
  }
}
```

### 8. استخدام Extension methods

```dart
Future<void> extensionMethodsExample() async {
  try {
    final response = await dio.get('/api/users');
    print('تم جلب البيانات بنجاح');
  } on DioException catch (e) {
    final exception = ExceptionHandler.handleDioException(e);
    final failure = ExceptionHandler.exceptionToFailure(exception);

    // استخدام Extension methods
    print('هل هو خطأ شبكة؟ ${failure.isNetworkError}');
    print('هل هو خطأ خادم؟ ${failure.isServerError}');
    print('هل هو خطأ تخزين؟ ${failure.isCacheError}');
    print('هل هو خطأ تحقق؟ ${failure.isValidationError}');
    print('هل هو خطأ مصادقة؟ ${failure.isAuthError}');

    // الحصول على رسالة مفهومة
    print('الرسالة: ${failure.userMessage}');
  }
}
```

### 9. استخدام النظام في StatefulWidget

```dart
class UserListWidget extends StatefulWidget {
  @override
  State<UserListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  final UsageExample _example = UsageExample();
  List<dynamic> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final users = await _example.fetchUsersWithRetry();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUsers,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return ListTile(
          title: Text(user['name'] ?? 'بدون اسم'),
          subtitle: Text(user['email'] ?? 'بدون بريد إلكتروني'),
        );
      },
    );
  }
}
```

## نصائح مهمة

### 1. استخدم try-catch دائماً

```dart
// ✅ صحيح
try {
  final response = await dio.get('/api/users');
} on DioException catch (e) {
  // معالجة الخطأ
}

// ❌ خطأ
final response = await dio.get('/api/users'); // قد يتوقف التطبيق
```

### 2. تحقق من نوع الخطأ

```dart
// ✅ صحيح
if (failure.isNetworkError) {
  // إعادة المحاولة
} else if (failure.isServerError) {
  // عرض رسالة خطأ خادم
}

// ❌ خطأ
// معالجة جميع الأخطاء بنفس الطريقة
```

### 3. استخدم رسائل خطأ واضحة

```dart
// ✅ صحيح
showErrorDialog(failure.userMessage);

// ❌ خطأ
showErrorDialog('Error occurred');
```

### 4. سجل الأخطاء للمطورين

```dart
try {
  final response = await dio.get('/api/users');
} on DioException catch (e) {
  // سجل الخطأ للمطورين
  logger.error('API Error: ${e.message}', e);

  // عرض رسالة للمستخدم
  final failure = ExceptionHandler.exceptionToFailure(
    ExceptionHandler.handleDioException(e)
  );
  showErrorDialog(failure.userMessage);
}
```

## الخلاصة

هذه الأمثلة توضح كيفية استخدام نظام معالجة الأخطاء في مشاريع Flutter الحقيقية. استخدمها كمرجع لبناء تطبيقات قوية ومستقرة.
