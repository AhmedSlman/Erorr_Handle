/// محتوى أقسام الشاشة
class SectionContent {
  /// محتوى قسم المقدمة
  static String get introductionContent => '''
في أي تطبيق حقيقي، تحدث أخطاء كثيرة:
• أخطاء الشبكة (انقطاع الإنترنت، بطء الاتصال)
• أخطاء الخادم (500, 404, 401, إلخ)
• أخطاء التحقق من صحة البيانات
• أخطاء التخزين المحلي
• أخطاء غير متوقعة

بدون نظام معالجة أخطاء منظم:
❌ التطبيق يتوقف عند حدوث خطأ
❌ رسائل خطأ غير واضحة للمستخدم
❌ صعوبة في تتبع وحل المشاكل
❌ تجربة مستخدم سيئة

مع نظام معالجة الأخطاء المنظم:
✅ التطبيق يستمر في العمل
✅ رسائل خطأ واضحة ومفيدة
✅ سهولة تتبع وحل المشاكل
✅ تجربة مستخدم ممتازة
  ''';

  /// محتوى قسم بنية النظام
  static String get architectureContent => '''
نظامنا يتكون من 3 طبقات رئيسية:

1️⃣ ErrorModel - نموذج البيانات
   • يحفظ تفاصيل الخطأ (الرسالة، الكود، أخطاء التحقق)
   • يدعم JSON parsing
   • يوفر methods مفيدة للوصول للبيانات

2️⃣ Exceptions - الاستثناءات
   • ServerException - أخطاء الخادم
   • NetworkException - أخطاء الشبكة
   • CacheException - أخطاء التخزين
   • ValidationException - أخطاء التحقق
   • ExceptionHandler - معالج الأخطاء الرئيسي

3️⃣ Failures - حالات الفشل
   • ServerFailure, NetworkFailure, إلخ
   • تحويل الاستثناءات إلى حالات فشل
   • رسائل خطأ باللغة العربية
   • Extension methods للتحقق من نوع الخطأ
  ''';

  /// محتوى قسم المثال العملي
  static String get practicalExampleContent => '''
// 1. استيراد المكتبة
import 'package:error_handler/error.dart';

// 2. استخدام try-catch مع Dio
try {
  final response = await dio.get('/api/users');
  // معالجة البيانات الناجحة
} on DioException catch (e) {
  // 3. تحويل DioException إلى AppException
  final exception = ExceptionHandler.handleDioException(e);
  
  // 4. تحويل AppException إلى Failure
  final failure = ExceptionHandler.exceptionToFailure(exception);
  
  // 5. عرض رسالة الخطأ للمستخدم
  showErrorDialog(failure.userMessage);
}
  ''';
}
