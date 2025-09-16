# مرجع معالجة الأخطاء - Error Handler Reference

## نظرة عامة

هذا المشروع هو مرجع بسيط وواضح لمعالجة الأخطاء في Flutter. يوضح كيفية بناء نظام معالجة أخطاء منظم يمكن استخدامه في أي مشروع.

## لماذا نحتاج نظام معالجة الأخطاء؟

### المشاكل بدون نظام معالجة أخطاء:

- ❌ التطبيق يتوقف عند حدوث خطأ
- ❌ رسائل خطأ غير واضحة للمستخدم
- ❌ صعوبة في تتبع وحل المشاكل
- ❌ تجربة مستخدم سيئة

### الفوائد مع نظام معالجة الأخطاء:

- ✅ التطبيق يستمر في العمل
- ✅ رسائل خطأ واضحة ومفيدة
- ✅ سهولة تتبع وحل المشاكل
- ✅ تجربة مستخدم ممتازة

## بنية النظام

### 1. ErrorModel - نموذج البيانات

```dart
class ErrorModel {
  final String message;           // رسالة الخطأ
  final String? status;          // حالة HTTP
  final String? code;            // كود الخطأ
  final Map<String, List<String>>? validationErrors; // أخطاء التحقق
  final Map<String, dynamic>? additionalData;        // بيانات إضافية
}
```

### 2. Exceptions - الاستثناءات

```dart
// الاستثناء الأساسي
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
}

// أنواع الاستثناءات
class ServerException extends AppException    // أخطاء الخادم
class NetworkException extends AppException   // أخطاء الشبكة
class CacheException extends AppException     // أخطاء التخزين
class ValidationException extends AppException // أخطاء التحقق
```

### 3. Failures - حالات الفشل

```dart
// الفشل الأساسي
abstract class Failure {
  final String message;
  final String? code;
  final dynamic originalError;
}

// أنواع حالات الفشل
class ServerFailure extends Failure
class NetworkFailure extends Failure
class CacheFailure extends Failure
class ValidationFailure extends Failure
class UnknownFailure extends Failure
```

### 4. ExceptionHandler - معالج الأخطاء

```dart
class ExceptionHandler {
  // تحويل DioException إلى AppException
  static AppException handleDioException(DioException e);

  // تحويل AppException إلى Failure
  static Failure exceptionToFailure(AppException exception);
}
```

## كيفية الاستخدام

### الاستخدام الأساسي

```dart
import 'package:error_handler/error.dart';

try {
  final response = await dio.get('/api/users');
  // معالجة البيانات الناجحة
} on DioException catch (e) {
  // تحويل DioException إلى AppException
  final exception = ExceptionHandler.handleDioException(e);

  // تحويل AppException إلى Failure
  final failure = ExceptionHandler.exceptionToFailure(exception);

  // عرض رسالة الخطأ للمستخدم
  showErrorDialog(failure.userMessage);
}
```

## أنواع الأخطاء المدعومة

### 1. NetworkException - أخطاء الشبكة

- انقطاع الإنترنت
- انتهاء مهلة الاتصال
- خطأ في الشهادة الأمنية
- إلغاء الطلب

### 2. ServerException - أخطاء الخادم

- 400: Bad Request
- 401: Unauthorized
- 403: Forbidden
- 404: Not Found
- 422: Validation Error
- 500: Internal Server Error
- 502: Bad Gateway
- 503: Service Unavailable

### 3. ValidationException - أخطاء التحقق

- حقول مطلوبة مفقودة
- تنسيق بيانات غير صحيح
- قيود التحقق من البيانات

### 4. CacheException - أخطاء التخزين

- فشل في حفظ البيانات
- فشل في قراءة البيانات
- مساحة تخزين ممتلئة

## أفضل الممارسات

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

### 2. رسائل خطأ واضحة

```dart
// ✅ صحيح
showErrorDialog(failure.userMessage);

// ❌ خطأ
showErrorDialog('Error occurred'); // رسالة غير واضحة
```

### 3. تحقق من نوع الخطأ

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

## التشغيل

```bash
flutter pub get
flutter run
```

## هيكل المشروع

```
lib/
├── main.dart                    # التطبيق الرئيسي
├── screens/
│   └── error_explanation_screen.dart  # شاشة الشرح
└── error/
    ├── error.dart              # ملف التصدير الرئيسي
    ├── error_model.dart        # نموذج بيانات الخطأ
    ├── exceptions.dart         # الاستثناءات
    ├── failures.dart          # حالات الفشل
    └── README.md              # توثيق مفصل
```

## الخلاصة

نظام معالجة الأخطاء هذا يوفر:

- **تنظيم واضح** للأخطاء
- **سهولة الاستخدام** في التطبيق
- **مرونة** في إضافة أنواع أخطاء جديدة
- **رسائل واضحة** للمستخدمين
- **تتبع سهل** للمشاكل

استخدم هذا النظام كأساس لبناء نظام معالجة أخطاء قوي في مشاريعك.
