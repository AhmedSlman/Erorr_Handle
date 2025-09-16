import 'package:flutter/material.dart';
import 'section_header.dart';

/// مكون قسم أفضل الممارسات
class BestPracticesSection extends StatelessWidget {
  const BestPracticesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'أفضل الممارسات', icon: Icons.star),
            const SizedBox(height: 16),
            _buildPracticeItem(
              context,
              '1',
              'استخدم try-catch دائماً',
              'احط كل استدعاء API بـ try-catch لمعالجة الأخطاء',
            ),
            _buildPracticeItem(
              context,
              '2',
              'رسائل خطأ واضحة',
              'استخدم failure.userMessage لعرض رسائل مفهومة للمستخدم',
            ),
            _buildPracticeItem(
              context,
              '3',
              'تحقق من نوع الخطأ',
              'استخدم failure.isNetworkError للتحقق من نوع الخطأ',
            ),
            _buildPracticeItem(
              context,
              '4',
              'إعادة المحاولة للأخطاء الشبكية',
              'أعد المحاولة عند أخطاء الشبكة، لا تعيد المحاولة عند أخطاء الخادم',
            ),
            _buildPracticeItem(
              context,
              '5',
              'سجل الأخطاء',
              'احفظ تفاصيل الأخطاء في logs للمطورين',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeItem(
    BuildContext context,
    String number,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
