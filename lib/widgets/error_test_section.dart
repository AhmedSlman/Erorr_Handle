import 'package:flutter/material.dart';
import 'section_header.dart';

/// مكون قسم اختبار الأخطاء
class ErrorTestSection extends StatefulWidget {
  final Function(String) onTestError;
  final String lastError;
  final bool isLoading;

  const ErrorTestSection({
    super.key,
    required this.onTestError,
    required this.lastError,
    required this.isLoading,
  });

  @override
  State<ErrorTestSection> createState() => _ErrorTestSectionState();
}

class _ErrorTestSectionState extends State<ErrorTestSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'تجربة النظام', icon: Icons.play_arrow),
            const SizedBox(height: 16),
            Text(
              'اضغط على الأزرار أدناه لمحاكاة أنواع مختلفة من الأخطاء ومعرفة كيف يتعامل معها النظام:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            _buildTestButtons(),
            if (widget.isLoading) _buildLoadingIndicator(),
            if (widget.lastError.isNotEmpty) _buildErrorDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButtons() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildTestButton('network', Icons.wifi_off, 'خطأ شبكة'),
        _buildTestButton('server', Icons.error, 'خطأ خادم'),
        _buildTestButton('validation', Icons.verified_user, 'خطأ تحقق'),
        _buildTestButton('cache', Icons.storage, 'خطأ تخزين'),
      ],
    );
  }

  Widget _buildTestButton(String errorType, IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: widget.isLoading ? null : () => widget.onTestError(errorType),
      icon: Icon(icon),
      label: Text(label),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.only(top: 16),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorDisplay() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          border: Border.all(color: Colors.red[200]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[700]),
                const SizedBox(width: 8),
                Text(
                  'الخطأ المُعالج:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(widget.lastError, style: TextStyle(color: Colors.red[700])),
          ],
        ),
      ),
    );
  }
}
