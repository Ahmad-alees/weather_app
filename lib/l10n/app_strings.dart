import 'package:flutter/widgets.dart';

class AppStrings {
  const AppStrings(this.locale);

  final Locale locale;

  bool get isArabic => locale.languageCode == 'ar';
  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  String get appName => 'Waether';
  String get genericRegion => isArabic ? 'موقعي' : 'My location';
  String get settings => isArabic ? 'الإعدادات' : 'Settings';
  String get lastUpdated => isArabic ? 'آخر تحديث' : 'Last updated';
  String get temperatureUnits =>
      isArabic ? 'وحدة الحرارة' : 'Temperature units';
  String get windUnits => isArabic ? 'وحدة الرياح' : 'Wind speed units';
  String get pressureUnits => isArabic ? 'وحدة الضغط' : 'Pressure units';
  String get language => isArabic ? 'اللغة' : 'Language';
  String get arabic => 'العربية';
  String get english => 'English';
  String get forecast => isArabic ? 'توقعات 5 أيام' : '5-day forecast';
  String get airQuality => isArabic ? 'جودة الهواء' : 'Air quality';
  String get humidity => isArabic ? 'الرطوبة' : 'Humidity';
  String get feelsLike => isArabic ? 'المحسوسة' : 'Feels like';
  String get uvIndex => isArabic ? 'مؤشر UV' : 'UV index';
  String get pressure => isArabic ? 'الضغط' : 'Pressure';
  String get rainChance => isArabic ? 'احتمال المطر' : 'Rain chance';
  String get wind => isArabic ? 'الرياح' : 'Wind';
  String get sunrise => isArabic ? 'الشروق' : 'Sunrise';
  String get sunset => isArabic ? 'الغروب' : 'Sunset';
  String get unavailable => isArabic ? 'غير متاح' : 'Unavailable';
  String get staleTitle => isArabic ? 'البيانات قديمة' : 'Data may be outdated';
  String get staleBody => isArabic
      ? 'تعذر تحديث الطقس. اعرض آخر بيانات محفوظة.'
      : 'Weather could not be updated. Showing saved data.';
  String get update => isArabic ? 'تحديث' : 'Update';
  String get noData => isArabic
      ? 'تعذر تحديد الطقس في مدينتك. شغّل الموقع أو الإنترنت ثم حاول مرة أخرى.'
      : 'The weather in your city can’t be determined. Turn on location or internet and try again.';
  String get locationUnavailable =>
      isArabic ? 'الموقع غير متاح' : 'Location unavailable';

  String condition(int code) => switch (code) {
    0 => isArabic ? 'مشمس' : 'Sunny',
    1 || 2 => isArabic ? 'غائم جزئياً' : 'Partly cloudy',
    3 => isArabic ? 'غائم' : 'Cloudy',
    45 || 48 => isArabic ? 'ضباب' : 'Fog',
    51 ||
    53 ||
    55 ||
    56 ||
    57 ||
    61 ||
    63 ||
    65 ||
    66 ||
    67 ||
    80 ||
    81 ||
    82 => isArabic ? 'ممطر' : 'Rainy',
    71 || 73 || 75 || 77 || 85 || 86 => isArabic ? 'ثلوج' : 'Snow',
    95 || 96 || 99 => isArabic ? 'عاصف' : 'Storm',
    _ => isArabic ? 'الطقس' : 'Weather',
  };
}
