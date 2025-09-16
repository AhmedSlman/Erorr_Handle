import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../error/error.dart';

/// مثال عملي لاستخدام نظام معالجة الأخطاء
///
/// هذا الملف يحتوي على أمثلة عملية لاستخدام النظام
/// في مشاريع Flutter الحقيقية

class UsageExample {
  final Dio _dio = Dio();

  /// مثال 1: الاستخدام الأساسي
  ///
  /// هذا المثال يوضح كيفية استخدام النظام في أبسط صورة
  Future<void> basicUsageExample() async {
    try {
      // محاولة جلب البيانات
      final response = await _dio.get('/api/users');

      // معالجة البيانات الناجحة
      print('تم جلب البيانات بنجاح: ${response.data}');
    } on DioException catch (e) {
      // معالجة أخطاء Dio
      final exception = ExceptionHandler.handleDioException(e);
      final failure = ExceptionHandler.exceptionToFailure(exception);

      // عرض رسالة الخطأ للمستخدم
      print('خطأ: ${failure.userMessage}');
    }
  }

  /// مثال 2: معالجة أخطاء في واجهة المستخدم
  ///
  /// هذا المثال يوضح كيفية استخدام النظام في واجهة المستخدم
  Future<void> uiErrorHandlingExample(BuildContext context) async {
    try {
      // إظهار مؤشر التحميل
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // جلب البيانات
      final response = await _dio.get('/api/users');

      // إخفاء مؤشر التحميل
      Navigator.of(context).pop();

      // معالجة البيانات الناجحة
      final users = response.data as List;
      print('تم جلب ${users.length} مستخدم');
    } on DioException catch (e) {
      // إخفاء مؤشر التحميل
      Navigator.of(context).pop();

      // معالجة الخطأ
      final exception = ExceptionHandler.handleDioException(e);
      final failure = ExceptionHandler.exceptionToFailure(exception);

      // عرض رسالة الخطأ للمستخدم
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure.userMessage),
          backgroundColor: failure.isNetworkError ? Colors.orange : Colors.red,
          action: failure.isNetworkError
              ? SnackBarAction(
                  label: 'إعادة المحاولة',
                  onPressed: () => uiErrorHandlingExample(context),
                )
              : null,
        ),
      );
    }
  }

  /// مثال 3: إعادة المحاولة للأخطاء الشبكية
  ///
  /// هذا المثال يوضح كيفية إعادة المحاولة للأخطاء الشبكية فقط
  Future<List<dynamic>> fetchUsersWithRetry() async {
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        final response = await _dio.get('/api/users');
        return response.data as List;
      } on DioException catch (e) {
        final exception = ExceptionHandler.handleDioException(e);
        final failure = ExceptionHandler.exceptionToFailure(exception);

        // إعادة المحاولة للأخطاء الشبكية فقط
        if (failure.isNetworkError && attempt < 3) {
          print('محاولة $attempt فشلت، إعادة المحاولة...');
          await Future.delayed(Duration(seconds: attempt));
          continue;
        }

        // إذا لم تكن خطأ شبكة أو انتهت المحاولات
        throw failure;
      }
    }

    throw const NetworkFailure();
  }

  /// مثال 4: معالجة أخطاء التحقق من البيانات
  ///
  /// هذا المثال يوضح كيفية معالجة أخطاء التحقق من البيانات
  bool validateUserData(Map<String, dynamic> userData) {
    final errors = <String, List<String>>{};

    // التحقق من الاسم
    if (userData['name'] == null || userData['name'].toString().isEmpty) {
      errors['name'] = ['الاسم مطلوب'];
    } else if (userData['name'].toString().length < 2) {
      errors['name'] = ['الاسم يجب أن يكون حرفين على الأقل'];
    }

    // التحقق من البريد الإلكتروني
    final email = userData['email']?.toString() ?? '';
    if (email.isEmpty) {
      errors['email'] = ['البريد الإلكتروني مطلوب'];
    } else if (!_isValidEmail(email)) {
      errors['email'] = ['البريد الإلكتروني غير صحيح'];
    }

    // التحقق من كلمة المرور
    final password = userData['password']?.toString() ?? '';
    if (password.isEmpty) {
      errors['password'] = ['كلمة المرور مطلوبة'];
    } else if (password.length < 8) {
      errors['password'] = ['كلمة المرور يجب أن تكون 8 أحرف على الأقل'];
    }

    if (errors.isNotEmpty) {
      // إنشاء ErrorModel للأخطاء
      final errorModel = ErrorModel(
        message: 'خطأ في التحقق من البيانات',
        validationErrors: errors,
      );

      // طباعة الأخطاء
      print('أخطاء التحقق:');
      errors.forEach((field, fieldErrors) {
        print('$field: ${fieldErrors.join(', ')}');
      });

      return false;
    }

    return true;
  }

  /// مثال 5: استخدام Result pattern
  ///
  /// هذا المثال يوضح كيفية استخدام Result pattern لمعالجة الأخطاء
  Future<Map<String, dynamic>> fetchUsersResult() async {
    try {
      final response = await _dio.get('/api/users');
      return {'success': true, 'data': response.data as List, 'error': null};
    } on DioException catch (e) {
      final exception = ExceptionHandler.handleDioException(e);
      final failure = ExceptionHandler.exceptionToFailure(exception);
      return {'success': false, 'data': null, 'error': failure};
    }
  }

  /// مثال 6: معالجة أخطاء متعددة الأنواع
  ///
  /// هذا المثال يوضح كيفية معالجة أنواع مختلفة من الأخطاء
  Future<void> handleMultipleErrorTypes() async {
    try {
      // محاولة جلب البيانات
      final response = await _dio.get('/api/users');
      print('تم جلب البيانات بنجاح');
    } on DioException catch (e) {
      final exception = ExceptionHandler.handleDioException(e);
      final failure = ExceptionHandler.exceptionToFailure(exception);

      // معالجة كل نوع خطأ بطريقة مختلفة
      if (failure.isNetworkError) {
        print('خطأ في الشبكة: ${failure.userMessage}');
        print('تحقق من اتصالك بالإنترنت');
      } else if (failure.isServerError) {
        print('خطأ في الخادم: ${failure.userMessage}');
        print('حاول مرة أخرى لاحقاً');
      } else if (failure.isValidationError) {
        print('خطأ في التحقق: ${failure.userMessage}');
        print('تحقق من البيانات المدخلة');
      } else {
        print('خطأ غير معروف: ${failure.userMessage}');
      }
    }
  }

  /// مثال 7: تسجيل الأخطاء
  ///
  /// هذا المثال يوضح كيفية تسجيل الأخطاء للمطورين
  Future<void> logErrorsExample() async {
    try {
      final response = await _dio.get('/api/users');
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

  /// مثال 8: استخدام Extension methods
  ///
  /// هذا المثال يوضح كيفية استخدام Extension methods
  Future<void> extensionMethodsExample() async {
    try {
      final response = await _dio.get('/api/users');
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

  /// دالة مساعدة للتحقق من صحة البريد الإلكتروني
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+').hasMatch(email);
  }
}

/// مثال 9: استخدام النظام في StatefulWidget
///
/// هذا المثال يوضح كيفية استخدام النظام في StatefulWidget
class UserListWidget extends StatefulWidget {
  const UserListWidget({super.key});

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
            Text(
              _errorMessage!,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
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
