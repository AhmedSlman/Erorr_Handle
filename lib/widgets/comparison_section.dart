import 'package:flutter/material.dart';
import 'section_header.dart';

/// مكون قسم المقارنة
class ComparisonSection extends StatelessWidget {
  const ComparisonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'مقارنة مع الطرق التقليدية',
              icon: Icons.compare,
            ),
            const SizedBox(height: 16),
            _buildTraditionalMethod(context),
            const SizedBox(height: 16),
            _buildErrorHandlerMethod(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTraditionalMethod(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '❌ الطريقة التقليدية:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 8),
          const Text('''try {
  final response = await dio.get('/api/users');
} catch (e) {
  // رسالة خطأ غير واضحة
  print('Error: \$e');
  // لا يوجد تمييز بين أنواع الأخطاء
  // صعوبة في معالجة الأخطاء المختلفة
}''', style: TextStyle(fontFamily: 'monospace', fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildErrorHandlerMethod(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        border: Border.all(color: Colors.green[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✅ مع نظام معالجة الأخطاء:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          const SizedBox(height: 8),
          const Text('''try {
  final response = await dio.get('/api/users');
} on DioException catch (e) {
  final exception = ExceptionHandler.handleDioException(e);
  final failure = ExceptionHandler.exceptionToFailure(exception);
  
  // رسالة خطأ واضحة ومفهومة
  showErrorDialog(failure.userMessage);
  
  // تمييز بين أنواع الأخطاء
  if (failure.isNetworkError) {
    // إعادة المحاولة
  } else if (failure.isServerError) {
    // عرض رسالة خطأ خادم
  }
}''', style: TextStyle(fontFamily: 'monospace', fontSize: 12)),
        ],
      ),
    );
  }
}
