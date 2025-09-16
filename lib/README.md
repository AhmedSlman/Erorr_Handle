# هيكل المشروع - Project Structure

```
lib/
├── main.dart                    # التطبيق الرئيسي
├── views/                       # الشاشات (Views)
│   └── error_explanation_view.dart
├── widgets/                     # المكونات (Widgets)
│   ├── section_header.dart
│   ├── info_section.dart
│   ├── error_test_section.dart
│   ├── error_types_section.dart
│   ├── best_practices_section.dart
│   ├── usage_examples_section.dart
│   └── comparison_section.dart
├── data/                        # البيانات (Data)
│   └── section_content.dart
├── error/                       # نظام معالجة الأخطاء
│   ├── error.dart
│   ├── error_model.dart
│   ├── exceptions.dart
│   ├── failures.dart
│   └── README.md
└── examples/                    # الأمثلة
    ├── usage_example.dart
    └── README.md
```

## 🏗️ طبقات المشروع

### 1. Views (الشاشات)

- **error_explanation_view.dart**: الشاشة الرئيسية التي تعرض شرح نظام معالجة الأخطاء

### 2. Widgets (المكونات)

- **section_header.dart**: مكون رأس القسم
- **info_section.dart**: مكون قسم المعلومات
- **error_test_section.dart**: مكون قسم اختبار الأخطاء
- **error_types_section.dart**: مكون قسم أنواع الأخطاء
- **best_practices_section.dart**: مكون قسم أفضل الممارسات
- **usage_examples_section.dart**: مكون قسم أمثلة الاستخدام
- **comparison_section.dart**: مكون قسم المقارنة

### 3. Data (البيانات)

- **section_content.dart**: محتوى أقسام الشاشة

### 4. Error (نظام معالجة الأخطاء)

- **error.dart**: ملف التصدير الرئيسي
- **error_model.dart**: نموذج بيانات الخطأ
- **exceptions.dart**: الاستثناءات
- **failures.dart**: حالات الفشل

### 5. Examples (الأمثلة)

- **usage_example.dart**: أمثلة شاملة لاستخدام النظام
- **README.md**: توثيق الأمثلة

## 🎯 المميزات

### ✅ التنظيم

- فصل المكونات إلى widgets منفصلة
- فصل البيانات إلى ملفات منفصلة
- فصل الشاشات إلى views منفصلة

### ✅ إعادة الاستخدام

- كل widget يمكن استخدامه في أماكن أخرى
- محتوى منفصل يمكن تعديله بسهولة
- مكونات قابلة للتخصيص

### ✅ الصيانة

- كود منظم وواضح
- سهولة إضافة مكونات جديدة
- سهولة تعديل المحتوى

### ✅ الأداء

- تحميل مكونات عند الحاجة فقط
- فصل منطق العرض عن البيانات
- كود محسن ومنظم

## 🚀 كيفية الاستخدام

### إضافة مكون جديد

1. أنشئ ملف جديد في مجلد `widgets/`
2. اتبع نفس نمط المكونات الموجودة
3. استورد المكون في الشاشة المطلوبة

### تعديل المحتوى

1. عدل الملف `data/section_content.dart`
2. استخدم المتغيرات في المكونات

### إضافة شاشة جديدة

1. أنشئ ملف جديد في مجلد `views/`
2. استخدم المكونات الموجودة
3. أضف الشاشة إلى التطبيق الرئيسي

## 📝 أمثلة

### استخدام مكون

```dart
import '../widgets/info_section.dart';

Widget build(BuildContext context) {
  return InfoSection(
    title: 'عنوان القسم',
    content: 'محتوى القسم',
    icon: Icons.info,
  );
}
```

### استخدام محتوى

```dart
import '../data/section_content.dart';

String content = SectionContent.introductionContent;
```

## 🔧 التطوير

### إضافة مكون جديد

```dart
// lib/widgets/new_section.dart
import 'package:flutter/material.dart';
import 'section_header.dart';

class NewSection extends StatelessWidget {
  const NewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SectionHeader(
              title: 'عنوان جديد',
              icon: Icons.new_releases,
            ),
            // باقي المحتوى...
          ],
        ),
      ),
    );
  }
}
```

### إضافة محتوى جديد

```dart
// lib/data/section_content.dart
class SectionContent {
  static String get newContent => '''
محتوى جديد هنا...
  ''';
}
```

## 📚 الخلاصة

هذا التنظيم الجديد يجعل المشروع:

- **أكثر تنظيماً** ووضوحاً
- **أسهل في الصيانة** والتطوير
- **أكثر مرونة** في التخصيص
- **أفضل أداءً** في التطبيق

استخدم هذا الهيكل كمرجع لتنظيم مشاريع Flutter الأخرى.
