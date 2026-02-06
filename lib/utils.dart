import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math' show sin, cos, sqrt, atan2, pi;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

/// 🛠️ UTILS - Fonctions utilitaires pour l'application Balagh Amen
class Utils {
  // ==================== CRYPTOGRAPHIE ====================

  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  static bool verifyPassword(String password, String hash) {
    return hashPassword(password) == hash;
  }

  // ==================== VALIDATIONS ====================

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidPhoneNumber(String phone) {
    // Validation : Exactement 10 chiffres commençant par 0
    return RegExp(r'^0[0-9]{9}$').hasMatch(phone);
  }

  static bool isValidNationalCard(String card) {
    // Validation : Exactement 8 chiffres
    return RegExp(r'^[0-9]{8}$').hasMatch(card);
  }

  // ==================== QUESTIONS DE SÉCURITÉ ====================

  static List<String> getSecurityQuestions(AppLocalizations l10n) {
    return [
      l10n.securityQuestion1,
      l10n.securityQuestion2,
      l10n.securityQuestion3,
      l10n.securityQuestion4,
      l10n.securityQuestion5,
      l10n.securityQuestion6,
      l10n.securityQuestion7,
      l10n.securityQuestion8,
      l10n.securityQuestion9,
      l10n.securityQuestion10,
      l10n.securityQuestion11,
      l10n.securityQuestion12,
      l10n.securityQuestion13,
      l10n.securityQuestion14,
      l10n.securityQuestion15,
    ];
  }

  // ==================== FORMATAGE DE TEXTE ====================

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // ==================== FORMATAGE DE DATES ====================

  static String formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);
  static String formatTime(DateTime date) => DateFormat('HH:mm').format(date);
  static String formatDateTime(DateTime date) => DateFormat('dd/MM/yyyy HH:mm').format(date);

  static String getRelativeTime(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) return l10n.justNow;
    if (difference.inMinutes < 60) return l10n.minutesAgo(difference.inMinutes);
    if (difference.inHours < 24) return l10n.hoursAgo(difference.inHours);
    if (difference.inDays < 7) return l10n.daysAgo(difference.inDays);
    if (difference.inDays < 30) return l10n.weeksAgo((difference.inDays / 7).floor());
    if (difference.inDays < 365) return l10n.monthsAgo((difference.inDays / 30).floor());
    return l10n.yearsAgo((difference.inDays / 365).floor());
  }

  // ==================== ALERT TYPES - LOCALISATION DYNAMIQUE ====================

  static Map<String, List<Map<String, String>>> getAlertTypesWithCategories(bool isArabic) {
    if (isArabic) {
      return {
        'جرائم ضد الأشخاص': [
          {'id': 'assault_wounding', 'name': 'اعتداء بالضرب والجرح العمدي'},
          {'id': 'assault_disability', 'name': 'الضرب المفضي إلى عاهة مستديمة'},
          {'id': 'assault_death', 'name': 'الضرب المفضي إلى الوفاة دون قصد القتل'},
          {'id': 'murder', 'name': 'القتل العمد'},
          {'id': 'manslaughter', 'name': 'القتل الخطأ'},
          {'id': 'threat', 'name': 'التهديد'},
          {'id': 'insult', 'name': 'السب والشتم'},
          {'id': 'slander', 'name': 'القذف'},
          {'id': 'kidnapping', 'name': 'الخطف'},
          {'id': 'illegal_detention', 'name': 'الاحتجاز غير القانوني'},
          {'id': 'no_assistance', 'name': 'عدم تقديم مساعدة لشخص في خطر'},
        ],
        'جرائم ضد الأموال': [
          {'id': 'theft', 'name': 'السرقة'},
          {'id': 'aggravated_theft', 'name': 'السرقة الموصوفة'},
          {'id': 'fraud', 'name': 'النصب والاحتيال'},
          {'id': 'breach_trust', 'name': 'خيانة الأمانة'},
          {'id': 'property_damage', 'name': 'إتلاف ملك الغير'},
          {'id': 'arson', 'name': 'الحريق العمد'},
          {'id': 'vandalism', 'name': 'تخريب ممتلكات'},
          {'id': 'real_estate_seizure', 'name': 'الاستيلاء على عقار'},
          {'id': 'looting', 'name': 'النهب'},
          {'id': 'trespassing', 'name': 'كسر حرمة محل'},
        ],
        'جرائم الأسرة': [
          {'id': 'family_neglect', 'name': 'إهمال الأسرة'},
          {'id': 'no_alimony', 'name': 'عدم دفع النفقة'},
          {'id': 'desertion_home', 'name': 'ترك مقر الأسرة'},
          {'id': 'endangering_minor', 'name': 'تعريض قاصر للخطر'},
          {'id': 'minor_maltreatment', 'name': 'سوء معاملة قاصر'},
          {'id': 'minor_kidnapping_parent', 'name': 'خطف قاصر من طرف أحد الوالدين'},
          {'id': 'forced_marriage', 'name': 'الزواج بدون رضا'},
          {'id': 'minor_marriage_no_license', 'name': 'الزواج بقاصر بدون ترخيص'},
          {'id': 'hiding_child', 'name': 'إخفاء طفل'},
          {'id': 'refusal_handover_child', 'name': 'الامتناع عن تسليم طفل للحاضن'},
          {'id': 'domestic_violence_wife', 'name': 'العنف الأسري ضد الزوجة'},
          {'id': 'domestic_violence_parents', 'name': 'العنف الأسري ضد الأصول (الوالدين)'},
        ],
        'جرائم الآداب العامة والأخلاق': [
          {'id': 'harassment', 'name': 'التحرش الجنسي'},
          {'id': 'public_indecency', 'name': 'الفعل المخل بالحياء'},
          {'id': 'rape', 'name': 'الاغتصاب'},
          {'id': 'indecent_assault', 'name': 'هتك العرض'},
          {'id': 'prostitution', 'name': 'الدعارة'},
          {'id': 'enticing_minor', 'name': 'استدراج قاصر لأفعال مخلة'},
          {'id': 'indecent_photos', 'name': 'نشر صور مخلة بالحياء'},
        ],
        'جرائم ضد النظام العام': [
          {'id': 'criminal_association', 'name': 'تكوين جمعية أشرار'},
          {'id': 'public_brawl', 'name': 'المشاجرة في الطريق العام'},
          {'id': 'illegal_assembly', 'name': 'التجمهر غير القانوني'},
          {'id': 'weapon_possession', 'name': 'حمل سلاح أبيض بدون مبرر'},
          {'id': 'disobedience', 'name': 'العصيان'},
          {'id': 'official_insult', 'name': 'إهانة موظف'},
          {'id': 'impersonation', 'name': 'انتحال صفة'},
        ],
        'التزوير واستعمال المزور': [
          {'id': 'official_doc_forgery', 'name': 'تزوير وثائق رسمية'},
          {'id': 'admin_doc_forgery', 'name': 'تزوير محررات إدارية'},
          {'id': 'use_forged_docs', 'name': 'استعمال المزور'},
          {'id': 'currency_counterfeiting', 'name': 'تزوير النقود'},
          {'id': 'seal_forgery', 'name': 'تزوير أختام الدولة'},
          {'id': 'medical_cert_forgery', 'name': 'تزوير شهادة طبية'},
        ],
        'جرائم المخدرات': [
          {'id': 'drug_possession', 'name': 'حيازة مخدرات'},
          {'id': 'drug_consumption', 'name': 'استهلاك مخدرات'},
          {'id': 'drug_trafficking', 'name': 'المتاجر بالمخدرات'},
          {'id': 'drug_transport', 'name': 'نقل المخدرات'},
          {'id': 'drug_cultivation', 'name': 'زراعة المخدرات'},
        ],
        'جرائم المرور': [
          {'id': 'driving_no_license', 'name': 'السياقة بدون رخصة'},
          {'id': 'drunk_driving', 'name': 'السياقة في حالة سكر'},
          {'id': 'accident_injury', 'name': 'حادث مرور مع جرح'},
          {'id': 'accident_death', 'name': 'حادث مرور مع وفاة'},
          {'id': 'hit_run', 'name': 'الفرار بعد حادث'},
          {'id': 'reckless_driving', 'name': 'السياقة المتهورة'},
        ],
        'الجرائم الإلكترونية': [
          {'id': 'hacking', 'name': 'اختراق حسابات'},
          {'id': 'cyber_extortion', 'name': 'ابتزاز إلكتروني'},
          {'id': 'photo_no_permission', 'name': 'نشر صور بدون إذن'},
          {'id': 'online_defamation', 'name': 'التشهير عبر الانترنت'},
          {'id': 'identity_theft', 'name': 'انتحال شخصية'},
          {'id': 'online_threat', 'name': 'تهديد عبر الانترنت'},
          {'id': 'website_piracy', 'name': 'قرصنة مواقع'},
        ],
        'جرائم الإرهاب والتخريب': [
          {'id': 'terrorist_group', 'name': 'الانتماء لجماعة إرهابية'},
          {'id': 'terrorist_financing', 'name': 'تمويل الإرهاب'},
          {'id': 'terrorist_propaganda', 'name': 'نشر أفكار إرهابية'},
          {'id': 'public_sabotage', 'name': 'تخريب منشآت عمومية'},
          {'id': 'explosives_possession', 'name': 'حيازة متفجرات'},
        ],
        'جرائم إدارية ووظيفية': [
          {'id': 'bribery', 'name': 'الرشوة'},
          {'id': 'influence_peddling', 'name': 'استغلال النفوذ'},
          {'id': 'public_funds_waste', 'name': 'تبديد المال العام'},
          {'id': 'abuse_function', 'name': 'إساءة استغلال الوظيفة'},
          {'id': 'professional_secrecy_breach', 'name': 'إفشاء السر المهني'},
          {'id': 'judgment_execution_refusal', 'name': 'رفض تنفيذ حكم قضائي'},
        ],
        'مخالفات متنوعة': [
          {'id': 'noise_disturbance', 'name': 'الضجيج والإزعاج'},
          {'id': 'littering', 'name': 'رمي النفايات'},
          {'id': 'road_occupation', 'name': 'احتلال الطريق العام'},
          {'id': 'no_permit_building', 'name': 'البناء بدون رخصة'},
          {'id': 'no_register_activity', 'name': 'ممارسة نشاط بدون سجل تجاري'},
          {'id': 'illegal_slaughter', 'name': 'ذبح سري'},
        ],
      };
    } else {
      return {
        'Crimes Against Persons': [
          {'id': 'assault_wounding', 'name': 'Assault and Intentional Wounding'},
          {'id': 'assault_disability', 'name': 'Assault leading to permanent disability'},
          {'id': 'assault_death', 'name': 'Assault leading to death without intent'},
          {'id': 'murder', 'name': 'Intentional Murder'},
          {'id': 'manslaughter', 'name': 'Involuntary Manslaughter'},
          {'id': 'threat', 'name': 'Threat'},
          {'id': 'insult', 'name': 'Insult and Verbal Abuse'},
          {'id': 'slander', 'name': 'Slander'},
          {'id': 'kidnapping', 'name': 'Kidnapping'},
          {'id': 'illegal_detention', 'name': 'Illegal Detention'},
          {'id': 'no_assistance', 'name': 'Failure to assist a person in danger'},
        ],
        'Crimes Against Property': [
          {'id': 'theft', 'name': 'Theft'},
          {'id': 'aggravated_theft', 'name': 'Aggravated Theft'},
          {'id': 'fraud', 'name': 'Financial Fraud'},
          {'id': 'breach_trust', 'name': 'Breach of Trust'},
          {'id': 'property_damage', 'name': 'Destruction of property'},
          {'id': 'arson', 'name': 'Arson'},
          {'id': 'vandalism', 'name': 'Vandalism'},
          {'id': 'real_estate_seizure', 'name': 'Seizure of real estate'},
          {'id': 'looting', 'name': 'Looting'},
          {'id': 'trespassing', 'name': 'Trespassing'},
        ],
        'Family Crimes': [
          {'id': 'family_neglect', 'name': 'Family neglect'},
          {'id': 'no_alimony', 'name': 'Failure to pay alimony'},
          {'id': 'desertion_home', 'name': 'Desertion of family home'},
          {'id': 'endangering_minor', 'name': 'Endangering a minor'},
          {'id': 'minor_maltreatment', 'name': 'Maltreatment of a minor'},
          {'id': 'minor_kidnapping_parent', 'name': 'Kidnapping of a minor by a parent'},
          {'id': 'forced_marriage', 'name': 'Marriage without consent'},
          {'id': 'minor_marriage_no_license', 'name': 'Marriage to a minor without license'},
          {'id': 'hiding_child', 'name': 'Hiding a child'},
          {'id': 'refusal_handover_child', 'name': 'Refusal to hand over a child'},
          {'id': 'domestic_violence_wife', 'name': 'Domestic violence against wife'},
          {'id': 'domestic_violence_parents', 'name': 'Domestic violence against parents'},
        ],
        'Public Morals Crimes': [
          {'id': 'harassment', 'name': 'Sexual harassment'},
          {'id': 'public_indecency', 'name': 'Public indecency'},
          {'id': 'rape', 'name': 'Rape'},
          {'id': 'indecent_assault', 'name': 'Indecent assault'},
          {'id': 'prostitution', 'name': 'Prostitution'},
          {'id': 'enticing_minor', 'name': 'Enticing a minor for indecent acts'},
          {'id': 'indecent_photos', 'name': 'Publishing indecent photos'},
        ],
        'Public Order Crimes': [
          {'id': 'criminal_association', 'name': 'Criminal association'},
          {'id': 'public_brawl', 'name': 'Brawling on public roads'},
          {'id': 'illegal_assembly', 'name': 'Illegal assembly'},
          {'id': 'weapon_possession', 'name': 'Weapon possession without justification'},
          {'id': 'disobedience', 'name': 'Disobedience'},
          {'id': 'official_insult', 'name': 'Insulting an official'},
          {'id': 'impersonation', 'name': 'Impersonation'},
        ],
        'Forgery and Counterfeiting': [
          {'id': 'official_doc_forgery', 'name': 'Forgery of official documents'},
          {'id': 'admin_doc_forgery', 'name': 'Forgery of admin documents'},
          {'id': 'use_forged_docs', 'name': 'Use of forged documents'},
          {'id': 'currency_counterfeiting', 'name': 'Currency counterfeiting'},
          {'id': 'seal_forgery', 'name': 'Forgery of state seals'},
          {'id': 'seal_forgery', 'name': 'Forgery of state seals'},
          {'id': 'medical_cert_forgery', 'name': 'Forgery of a medical certificate'},
        ],
        'Drug Crimes': [
          {'id': 'drug_possession', 'name': 'Drug possession'},
          {'id': 'drug_consumption', 'name': 'Drug consumption'},
          {'id': 'drug_trafficking', 'name': 'Drug trafficking'},
          {'id': 'drug_transport', 'name': 'Drug transport'},
          {'id': 'drug_cultivation', 'name': 'Drug cultivation'},
        ],
        'Traffic Crimes': [
          {'id': 'driving_no_license', 'name': 'Driving without a license'},
          {'id': 'drunk_driving', 'name': 'Drunk driving'},
          {'id': 'accident_injury', 'name': 'Traffic accident with injury'},
          {'id': 'accident_death', 'name': 'Traffic accident with death'},
          {'id': 'hit_run', 'name': 'Hit and run'},
          {'id': 'reckless_driving', 'name': 'Reckless driving'},
        ],
        'Cybercrimes': [
          {'id': 'hacking', 'name': 'Account hacking'},
          {'id': 'cyber_extortion', 'name': 'Cyber extortion'},
          {'id': 'photo_no_permission', 'name': 'Publishing photos without permission'},
          {'id': 'online_defamation', 'name': 'Online defamation'},
          {'id': 'identity_theft', 'name': 'Identity theft'},
          {'id': 'online_threat', 'name': 'Online threat'},
          {'id': 'website_piracy', 'name': 'Website piracy'},
        ],
        'Terrorism and Sabotage': [
          {'id': 'terrorist_group', 'name': 'Belonging to a terrorist group'},
          {'id': 'terrorist_financing', 'name': 'Financing terrorism'},
          {'id': 'terrorist_propaganda', 'name': 'Spreading terrorist ideas'},
          {'id': 'public_sabotage', 'name': 'Sabotage of public facilities'},
          {'id': 'explosives_possession', 'name': 'Possession of explosives'},
        ],
        'Administrative Crimes': [
          {'id': 'bribery', 'name': 'Bribery'},
          {'id': 'influence_peddling', 'name': 'Influence peddling'},
          {'id': 'public_funds_waste', 'name': 'Squandering public funds'},
          {'id': 'abuse_function', 'name': 'Abuse of function'},
          {'id': 'professional_secrecy_breach', 'name': 'Breach of professional secrecy'},
          {'id': 'judgment_execution_refusal', 'name': 'Refusal to execute court judgment'},
        ],
        'Miscellaneous Violations': [
          {'id': 'noise_disturbance', 'name': 'Noise and disturbance'},
          {'id': 'littering', 'name': 'Littering'},
          {'id': 'road_occupation', 'name': 'Occupation of public road'},
          {'id': 'no_permit_building', 'name': 'Building without a license'},
          {'id': 'no_register_activity', 'name': 'Activity without commercial register'},
          {'id': 'illegal_slaughter', 'name': 'Illegal slaughter'},
        ],
      };
    }
  }

  /// Récupère le nom localisé à partir de l'ID enregistré
  static String getAlertTypeName(String id, bool isArabic) {
    final categories = getAlertTypesWithCategories(isArabic);
    for (var types in categories.values) {
      for (var type in types) {
        if (type['id'] == id) return type['name']!;
      }
    }
    return id; // Retourne l'ID si non trouvé
  }

  static List<String> getAlertTypes(bool isArabic) {
    final List<String> allTypes = [];
    getAlertTypesWithCategories(isArabic).values.forEach((types) {
      allTypes.addAll(types.map((t) => t['name']!));
    });
    return allTypes;
  }

  static String formatAccuracy(double accuracy, AppLocalizations l10n) {
    if (accuracy < 10) return '${l10n.gpsExcellent} (${accuracy.toStringAsFixed(1)}m)';
    if (accuracy < 50) return '${l10n.gpsGood} (${accuracy.toStringAsFixed(1)}m)';
    return '${l10n.gpsPoor} (${accuracy.toStringAsFixed(1)}m)';
  }

  static int getAccuracyColor(double accuracy) {
    if (accuracy < 10) return 0xFF4CAF50;
    if (accuracy < 50) return 0xFF8BC34A;
    return 0xFFF44336;
  }
}
