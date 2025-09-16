# نظام معالجة الأخطاء - Error Handling System

## نظرة عامة

هذا المجلد يحتوي على نظام معالجة الأخطاء الكامل للتطبيق. النظام مصمم ليكون:

- **منظماً**: كل نوع خطأ له كلاس منفصل
- **قابلاً للتوسع**: يمكن إضافة أنواع أخطاء جديدة بسهولة
- **سهل الاستخدام**: واجهة بسيطة وواضحة
- **مفهوماً**: رسائل خطأ باللغة العربية

## هيكل الملفات

```
lib/error/
├── error.dart              # ملف التصدير الرئيسي
├── error_model.dart        # نموذج بيانات الخطأ
├── exceptions.dart         # الاستثناءات
├── failures.dart          # حالات الفشل
└── README.md              # هذا الملف
```

## شرح الملفات

### 1. error_model.dart

**الغرض**: نموذج بيانات لتمثيل الخطأ

**المميزات**:

- يحفظ تفاصيل الخطأ (الرسالة، الكود، أخطاء التحقق)
- يدعم تحويل من/إلى JSON
- يوفر methods مساعدة للوصول للبيانات
- يدعم أخطاء التحقق المتعددة

**الاستخدام**:

```dart
// إنشاء ErrorModel من JSON
final errorModel = ErrorModel.fromJson(response.data);

// الحصول على أول خطأ تحقق
final firstError = errorModel.getFirstValidationError();

// الحصول على جميع أخطاء التحقق
final allErrors = errorModel.getAllValidationErrors();

// التحقق من وجود أخطاء تحقق
if (errorModel.hasValidationErrors) {
  // معالجة أخطاء التحقق
}
```

### 2. exceptions.dart

**الغرض**: تعريف الاستثناءات المختلفة

**الأنواع**:

- `AppException`: الاستثناء الأساسي
- `ServerException`: أخطاء الخادم (API)
- `NetworkException`: أخطاء الشبكة
- `CacheException`: أخطاء التخزين المحلي
- `ValidationException`: أخطاء التحقق من البيانات
- `ExceptionHandler`: معالج الأخطاء الرئيسي

**الاستخدام**:

```dart
try {
  final response = await dio.get('/api/users');
} on DioException catch (e) {
  // تحويل DioException إلى AppException
  final exception = ExceptionHandler.handleDioException(e);

  // تحويل AppException إلى Failure
  final failure = ExceptionHandler.exceptionToFailure(exception);
}
```

### 3. failures.dart

**الغرض**: تمثيل حالات الفشل في التطبيق

**الأنواع**:

- `Failure`: الفشل الأساسي
- `ServerFailure`: فشل في الخادم
- `NetworkFailure`: فشل في الشبكة
- `CacheFailure`: فشل في التخزين
- `ValidationFailure`: فشل في التحقق
- `UnknownFailure`: فشل غير معروف

**Extension Methods**:

```dart
// التحقق من نوع الخطأ
if (failure.isNetworkError) {
  // معالجة أخطاء الشبكة
}

if (failure.isServerError) {
  // معالجة أخطاء الخادم
}

// الحصول على رسالة خطأ مفهومة
final userMessage = failure.userMessage;
```

### 4. error.dart

**الغرض**: ملف التصدير الرئيسي

**المحتوى**:

```dart
export 'error_model.dart';
export 'exceptions.dart';
export 'failures.dart';
```

## تدفق معالجة الأخطاء

```
1. حدوث خطأ (DioException)
   ↓
2. ExceptionHandler.handleDioException()
   ↓
3. تحويل إلى AppException مناسبة
   ↓
4. ExceptionHandler.exceptionToFailure()
   ↓
5. تحويل إلى Failure
   ↓
6. عرض رسالة الخطأ للمستخدم
```

## أمثلة عملية

### مثال 1: معالجة أخطاء API

```dart
Future<void> fetchUsers() async {
  try {
    final response = await dio.get('/api/users');
    final users = (response.data as List)
        .map((json) => User.fromJson(json))
        .toList();

    // تحديث UI
    setState(() {
      this.users = users;
    });

  } on DioException catch (e) {
    final exception = ExceptionHandler.handleDioException(e);
    final failure = ExceptionHandler.exceptionToFailure(exception);

    // عرض رسالة الخطأ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failure.userMessage),
        backgroundColor: failure.isNetworkError ? Colors.orange : Colors.red,
      ),
    );
  }
}
```

### مثال 2: معالجة أخطاء التحقق

```dart
void validateAndSubmit() {
  final userData = {
    'name': nameController.text,
    'email': emailController.text,
    'password': passwordController.text,
  };

  final validationResult = validateUser(userData);

  if (validationResult.isSuccess) {
    // إرسال البيانات
    submitUser(userData);
  } else {
    // عرض أخطاء التحقق
    showValidationErrors(validationResult.errors);
  }
}
```

### مثال 3: إعادة المحاولة للأخطاء الشبكية

```dart
Future<Result<List<User>, Failure>> fetchUsersWithRetry() async {
  for (int attempt = 1; attempt <= 3; attempt++) {
    try {
      final response = await dio.get('/api/users');
      final users = (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();

      return Result.success(users);

    } on DioException catch (e) {
      final exception = ExceptionHandler.handleDioException(e);
      final failure = ExceptionHandler.exceptionToFailure(exception);

      // إعادة المحاولة للأخطاء الشبكية فقط
      if (failure.isNetworkError && attempt < 3) {
        await Future.delayed(Duration(seconds: attempt));
        continue;
      }

      return Result.failure(failure);
    }
  }

  return Result.failure(const NetworkFailure());
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

## إضافة أنواع أخطاء جديدة

### 1. إضافة استثناء جديد

```dart
class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'DatabaseException: $message';
}
```

### 2. إضافة فشل جديد

```dart
class DatabaseFailure extends Failure {
  const DatabaseFailure({
    super.message = 'حدث خطأ في قاعدة البيانات',
    super.code = 'DATABASE_ERROR',
    super.originalError,
  });

  @override
  String toString() => 'DatabaseFailure: $message';
}
```

### 3. تحديث ExceptionHandler

```dart
static Failure exceptionToFailure(AppException exception) {
  if (exception is ServerException) {
    return ServerFailure(message: exception.message);
  } else if (exception is NetworkException) {
    return NetworkFailure(message: exception.message);
  } else if (exception is DatabaseException) {
    return DatabaseFailure(message: exception.message);
  }
  // ... باقي الأنواع
}
```

## الاختبار

### اختبار معالجة الأخطاء

```dart
test('should handle network error correctly', () async {
  // إعداد mock للخطأ
  when(mockDio.get(any)).thenThrow(
    DioException(
      type: DioExceptionType.connectionTimeout,
      message: 'Connection timeout',
    ),
  );

  // استدعاء الدالة
  final result = await userRepository.fetchUsers();

  // التحقق من النتيجة
  expect(result.isFailure, true);
  expect(result.error, isA<NetworkFailure>());
});
```

## الخلاصة

نظام معالجة الأخطاء هذا يوفر:

- **تنظيم واضح** للأخطاء
- **سهولة الاستخدام** في التطبيق
- **مرونة** في إضافة أنواع أخطاء جديدة
- **رسائل واضحة** للمستخدمين
- **تتبع سهل** للمشاكل

استخدم هذا النظام كأساس لبناء نظام معالجة أخطاء قوي في مشاريعك.
