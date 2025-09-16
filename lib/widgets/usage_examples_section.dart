import 'package:flutter/material.dart';
import 'section_header.dart';

/// مكون قسم أمثلة الاستخدام
class UsageExamplesSection extends StatelessWidget {
  const UsageExamplesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'أمثلة الاستخدام', icon: Icons.code),
            const SizedBox(height: 16),
            Text(
              'إليك أمثلة عملية لاستخدام نظام معالجة الأخطاء:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            _buildCodeExample(
              context,
              '1. الاستخدام الأساسي',
              _getBasicUsageCode(),
            ),
            _buildCodeExample(
              context,
              '2. معالجة في واجهة المستخدم',
              _getUIHandlingCode(),
            ),
            _buildCodeExample(
              context,
              '3. إعادة المحاولة للأخطاء الشبكية',
              _getRetryCode(),
            ),
            _buildCodeExample(
              context,
              '4. استخدام Result pattern',
              _getResultPatternCode(),
            ),
            const SizedBox(height: 16),
            _buildInfoNote(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeExample(BuildContext context, String title, String code) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              code,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoNote(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(color: Colors.blue[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Text(
                'ملاحظة:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'لمزيد من الأمثلة التفصيلية، راجع ملف lib/examples/usage_example.dart',
            style: TextStyle(color: Colors.blue[700]),
          ),
        ],
      ),
    );
  }

  String _getBasicUsageCode() {
    return '''try {
  final response = await dio.get('/api/users');
  print('تم جلب البيانات بنجاح');
} on DioException catch (e) {
  final exception = ExceptionHandler.handleDioException(e);
  final failure = ExceptionHandler.exceptionToFailure(exception);
  print('خطأ: \${failure.userMessage}');
}''';
  }

  String _getUIHandlingCode() {
    return '''try {
  final response = await dio.get('/api/users');
  // تحديث UI
} on DioException catch (e) {
  final failure = ExceptionHandler.exceptionToFailure(
    ExceptionHandler.handleDioException(e)
  );
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(failure.userMessage)),
  );
}''';
  }

  String _getRetryCode() {
    return '''for (int attempt = 1; attempt <= 3; attempt++) {
  try {
    final response = await dio.get('/api/users');
    return response.data;
  } on DioException catch (e) {
    final failure = ExceptionHandler.exceptionToFailure(
      ExceptionHandler.handleDioException(e)
    );
    
    if (failure.isNetworkError && attempt < 3) {
      await Future.delayed(Duration(seconds: attempt));
      continue;
    }
    throw failure;
  }
}''';
  }

  String _getResultPatternCode() {
    return '''Future<Result<List<User>, Failure>> fetchUsers() async {
  try {
    final response = await dio.get('/api/users');
    return Result.success(response.data);
  } on DioException catch (e) {
    final failure = ExceptionHandler.exceptionToFailure(
      ExceptionHandler.handleDioException(e)
    );
    return Result.failure(failure);
  }
}

// الاستخدام
fetchUsers()
  .onSuccess((users) => print('تم جلب \${users.length} مستخدم'))
  .onFailure((error) => print('خطأ: \${error.userMessage}'));''';
  }
}
