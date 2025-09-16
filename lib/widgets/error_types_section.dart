import 'package:flutter/material.dart';
import 'section_header.dart';

/// مكون قسم أنواع الأخطاء
class ErrorTypesSection extends StatelessWidget {
  const ErrorTypesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'أنواع الأخطاء المدعومة',
              icon: Icons.category,
            ),
            const SizedBox(height: 16),
            _buildErrorTypeItem(
              context,
              'NetworkException',
              'أخطاء الشبكة',
              'انقطاع الإنترنت، انتهاء المهلة، خطأ في الشهادة',
              Colors.orange,
            ),
            _buildErrorTypeItem(
              context,
              'ServerException',
              'أخطاء الخادم',
              '500, 404, 401, 403, 422 - أخطاء HTTP',
              Colors.red,
            ),
            _buildErrorTypeItem(
              context,
              'ValidationException',
              'أخطاء التحقق',
              'بيانات غير صحيحة، حقول مطلوبة مفقودة',
              Colors.blue,
            ),
            _buildErrorTypeItem(
              context,
              'CacheException',
              'أخطاء التخزين',
              'فشل في حفظ/قراءة البيانات المحلية',
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorTypeItem(
    BuildContext context,
    String code,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  code,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
