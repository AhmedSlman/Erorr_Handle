import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../error/error.dart';
import '../widgets/info_section.dart';
import '../widgets/error_test_section.dart';
import '../widgets/error_types_section.dart';
import '../widgets/best_practices_section.dart';
import '../widgets/usage_examples_section.dart';
import '../widgets/comparison_section.dart';
import '../data/section_content.dart';

class ErrorExplanationView extends StatefulWidget {
  const ErrorExplanationView({super.key});

  @override
  State<ErrorExplanationView> createState() => _ErrorExplanationViewState();
}

class _ErrorExplanationViewState extends State<ErrorExplanationView> {
  final Dio _dio = Dio();
  String _lastError = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIntroductionSection(),
            const SizedBox(height: 24),
            _buildArchitectureSection(),
            const SizedBox(height: 24),
            _buildPracticalExampleSection(),
            const SizedBox(height: 24),
            _buildTestSection(),
            const SizedBox(height: 24),
            _buildErrorTypesSection(),
            const SizedBox(height: 24),
            _buildBestPracticesSection(),
            const SizedBox(height: 24),
            _buildUsageExamplesSection(),
            const SizedBox(height: 24),
            _buildComparisonSection(),
          ],
        ),
      ),
    );
  }

  /// بناء شريط التطبيق
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('مرجع معالجة الأخطاء'),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }

  /// بناء قسم المقدمة
  Widget _buildIntroductionSection() {
    return InfoSection(
      title: 'مقدمة: لماذا نحتاج نظام معالجة الأخطاء؟',
      content: SectionContent.introductionContent,
      icon: Icons.info,
    );
  }

  /// بناء قسم بنية النظام
  Widget _buildArchitectureSection() {
    return InfoSection(
      title: 'بنية نظام معالجة الأخطاء',
      content: SectionContent.architectureContent,
      icon: Icons.architecture,
    );
  }

  /// بناء قسم المثال العملي
  Widget _buildPracticalExampleSection() {
    return InfoSection(
      title: 'مثال عملي: كيف يعمل النظام',
      content: SectionContent.practicalExampleContent,
      icon: Icons.code,
    );
  }

  /// بناء قسم تجربة النظام
  Widget _buildTestSection() {
    return ErrorTestSection(
      onTestError: _testError,
      lastError: _lastError,
      isLoading: _isLoading,
    );
  }

  /// بناء قسم أنواع الأخطاء
  Widget _buildErrorTypesSection() {
    return const ErrorTypesSection();
  }

  /// بناء قسم أفضل الممارسات
  Widget _buildBestPracticesSection() {
    return const BestPracticesSection();
  }

  /// بناء قسم أمثلة الاستخدام
  Widget _buildUsageExamplesSection() {
    return const UsageExamplesSection();
  }

  /// بناء قسم المقارنة
  Widget _buildComparisonSection() {
    return const ComparisonSection();
  }

  /// اختبار أنواع مختلفة من الأخطاء
  Future<void> _testError(String errorType) async {
    setState(() {
      _isLoading = true;
      _lastError = '';
    });

    try {
      // محاكاة أنواع مختلفة من الأخطاء
      switch (errorType) {
        case 'network':
          await _dio.get('https://invalid-url-that-will-fail.com');
          break;
        case 'server':
          await _dio.get('https://httpstat.us/500');
          break;
        case 'validation':
          await _dio.get('https://httpstat.us/422');
          break;
        case 'cache':
          // محاكاة خطأ تخزين
          throw const CacheException(message: 'فشل في حفظ البيانات محلياً');
      }
    } on DioException catch (e) {
      final exception = ExceptionHandler.handleDioException(e);
      final failure = ExceptionHandler.exceptionToFailure(exception);

      setState(() {
        _lastError = '${failure.runtimeType}: ${failure.userMessage}';
        _isLoading = false;
      });
    } on CacheException catch (e) {
      setState(() {
        _lastError = '${e.runtimeType}: ${e.message}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _lastError = 'خطأ غير متوقع: $e';
        _isLoading = false;
      });
    }
  }
}
