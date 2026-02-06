// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'بلاغ أمان';

  @override
  String get appDescription => 'تطبيق التبليغ عن الجرائم والحوادث';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get ok => 'حسناً';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get close => 'إغلاق';

  @override
  String get back => 'رجوع';

  @override
  String get next => 'التالي';

  @override
  String get previous => 'السابق';

  @override
  String get submit => 'إرسال';

  @override
  String get confirm => 'تأكيد';

  @override
  String get search => 'بحث';

  @override
  String get filter => 'تصفية';

  @override
  String get refresh => 'تحديث';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجاح';

  @override
  String get warning => 'تحذير';

  @override
  String get info => 'معلومات';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get register => 'التسجيل';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get firstName => 'الاسم';

  @override
  String get lastName => 'اللقب';

  @override
  String get nationalCard => 'رقم البطاقة الوطنية';

  @override
  String get securityQuestions => 'الأسئلة الأمنية';

  @override
  String get answer => 'الإجابة';

  @override
  String get loginWelcome => 'مرحباً بعودتك';

  @override
  String get loginSubtitle => 'سجل دخولك للمتابعة';

  @override
  String get registerWelcome => 'إنشاء حساب جديد';

  @override
  String get registerSubtitle => 'انضم إلينا للإبلاغ عن الجرائم';

  @override
  String get phoneHint => '05xxxxxxxx';

  @override
  String get passwordHint => 'على الأقل 6 أحرف';

  @override
  String get firstNameHint => 'أدخل اسمك';

  @override
  String get lastNameHint => 'أدخل لقبك';

  @override
  String get nationalCardHint => '18 رقماً';

  @override
  String get errorInvalidPhone => 'رقم الهاتف غير صحيح';

  @override
  String get errorInvalidPassword =>
      'كلمة المرور يجب أن تحتوي على 6 أحرف على الأقل';

  @override
  String get errorPasswordMismatch => 'كلمات المرور غير متطابقة';

  @override
  String get errorInvalidNationalCard =>
      'رقم البطاقة الوطنية غير صحيح (18 رقماً)';

  @override
  String get errorLoginFailed => 'فشل تسجيل الدخول';

  @override
  String get errorRegisterFailed => 'فشل التسجيل';

  @override
  String get errorUserNotFound => 'المستخدم غير موجود';

  @override
  String get errorWrongPassword => 'كلمة المرور خاطئة';

  @override
  String get successLogin => 'تم تسجيل الدخول بنجاح';

  @override
  String get successRegister => 'تم التسجيل بنجاح';

  @override
  String get successLogout => 'تم تسجيل الخروج';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navAlerts => 'التنبيهات';

  @override
  String get navMap => 'الخريطة';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get navDashboard => 'لوحة التحكم';

  @override
  String get navUsers => 'المستخدمون';

  @override
  String get navFeedback => 'الملاحظات';

  @override
  String get alerts => 'التنبيهات';

  @override
  String get myAlerts => 'تنبيهاتي';

  @override
  String get createAlert => 'إنشاء تنبيه';

  @override
  String get alertDetails => 'تفاصيل التنبيه';

  @override
  String get alertType => 'نوع التنبيه';

  @override
  String get alertDescription => 'وصف التنبيه';

  @override
  String get alertLocation => 'الموقع';

  @override
  String get alertPhotos => 'الصور';

  @override
  String get alertStatus => 'الحالة';

  @override
  String get alertDate => 'التاريخ';

  @override
  String get alertTime => 'الوقت';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get statusInProgress => 'قيد المعالجة';

  @override
  String get statusResolved => 'تم الحل';

  @override
  String get selectAlertType => 'اختر نوع التنبيه';

  @override
  String get describeAlert => 'صف المشكلة بالتفصيل...';

  @override
  String get addPhotos => 'إضافة صور';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get chooseFromGallery => 'اختر من المعرض';

  @override
  String get locationAccuracy => 'دقة الموقع';

  @override
  String get errorNoType => 'الرجاء اختيار نوع التنبيه';

  @override
  String get errorNoDescription => 'الرجاء وصف المشكلة';

  @override
  String get errorNoLocation => 'لا يمكن الحصول على موقعك';

  @override
  String get errorLocationPermission => 'الرجاء السماح بالوصول إلى الموقع';

  @override
  String get successAlertCreated => 'تم إنشاء التنبيه بنجاح';

  @override
  String get successAlertUpdated => 'تم تحديث التنبيه';

  @override
  String get successAlertDeleted => 'تم حذف التنبيه';

  @override
  String get confirmDeleteAlert => 'هل أنت متأكد من حذف هذا التنبيه؟';

  @override
  String get noAlerts => 'لا توجد تنبيهات';

  @override
  String get noAlertsFiltered => 'لا توجد تنبيهات بهذه الحالة';

  @override
  String get messages => 'الرسائل';

  @override
  String get sendMessage => 'إرسال رسالة';

  @override
  String get typeMessage => 'اكتب رسالة...';

  @override
  String get noMessages => 'لا توجد رسائل';

  @override
  String get messageFrom => 'من';

  @override
  String get messageTo => 'إلى';

  @override
  String get admin => 'المدير';

  @override
  String get user => 'المستخدم';

  @override
  String get successMessageSent => 'تم إرسال الرسالة';

  @override
  String get errorMessageFailed => 'فشل إرسال الرسالة';

  @override
  String get map => 'الخريطة';

  @override
  String get showOnMap => 'عرض على الخريطة';

  @override
  String get myLocation => 'موقعي';

  @override
  String get alertsOnMap => 'التنبيهات على الخريطة';

  @override
  String get gpsExcellent => 'ممتازة';

  @override
  String get gpsGood => 'جيدة';

  @override
  String get gpsAverage => 'متوسطة';

  @override
  String get gpsPoor => 'ضعيفة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get accountSettings => 'إعدادات الحساب';

  @override
  String get appSettings => 'إعدادات التطبيق';

  @override
  String get theme => 'المظهر';

  @override
  String get language => 'اللغة';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get about => 'حول';

  @override
  String get help => 'مساعدة';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get terms => 'الشروط';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'تلقائي (النظام)';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get notificationsEnabled => 'تفعيل الإشعارات';

  @override
  String get notificationsAlerts => 'إشعارات التنبيهات';

  @override
  String get notificationsMessages => 'إشعارات الرسائل';

  @override
  String get notificationsStatus => 'إشعارات تغيير الحالة';

  @override
  String get feedback => 'ملاحظاتك';

  @override
  String get sendFeedback => 'إرسال ملاحظة';

  @override
  String get feedbackMessage => 'اكتب ملاحظتك أو اقتراحك...';

  @override
  String get feedbackPlaceholder => 'شاركنا رأيك لتحسين التطبيق';

  @override
  String get rateApp => 'قيّم التطبيق';

  @override
  String get myFeedback => 'ملاحظاتي';

  @override
  String get adminReply => 'رد الإدارة';

  @override
  String get noFeedback => 'لا توجد ملاحظات';

  @override
  String get feedbackStatusPending => 'قيد الانتظار';

  @override
  String get feedbackStatusRead => 'تمت القراءة';

  @override
  String get feedbackStatusReplied => 'تم الرد';

  @override
  String get successFeedbackSent => 'تم إرسال ملاحظتك بنجاح';

  @override
  String get errorFeedbackTooShort =>
      'الرسالة يجب أن تحتوي على 10 أحرف على الأقل';

  @override
  String get errorNoRating => 'الرجاء إعطاء تقييم';

  @override
  String get adminPanel => 'لوحة الإدارة';

  @override
  String get adminDashboard => 'لوحة التحكم';

  @override
  String get totalAlerts => 'إجمالي التنبيهات';

  @override
  String get totalUsers => 'المستخدمون';

  @override
  String get pendingAlerts => 'قيد الانتظار';

  @override
  String get inProgressAlerts => 'قيد المعالجة';

  @override
  String get resolvedAlerts => 'تم الحل';

  @override
  String get changeStatus => 'تغيير الحالة';

  @override
  String get replyToFeedback => 'الرد على الملاحظة';

  @override
  String get yourReply => 'ردك';

  @override
  String get userDetails => 'تفاصيل المستخدم';

  @override
  String get userFullName => 'الاسم الكامل';

  @override
  String get userPhone => 'رقم الهاتف';

  @override
  String get userNationalCard => 'رقم البطاقة الوطنية';

  @override
  String get userAlertsCount => 'عدد التنبيهات';

  @override
  String get successStatusChanged => 'تم تحديث الحالة';

  @override
  String get successReplyAdded => 'تم إرسال الرد بنجاح';

  @override
  String get statistics => 'الإحصائيات';

  @override
  String get today => 'اليوم';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get allTime => 'كل الوقت';

  @override
  String get justNow => 'الآن';

  @override
  String get minuteAgo => 'منذ دقيقة';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count دقائق';
  }

  @override
  String get hourAgo => 'منذ ساعة';

  @override
  String hoursAgo(Object count) {
    return 'منذ $count ساعات';
  }

  @override
  String get dayAgo => 'منذ يوم';

  @override
  String daysAgo(Object count) {
    return 'منذ $count أيام';
  }

  @override
  String get weekAgo => 'منذ أسبوع';

  @override
  String weeksAgo(Object count) {
    return 'منذ $count أسابيع';
  }

  @override
  String get monthAgo => 'منذ شهر';

  @override
  String monthsAgo(Object count) {
    return 'منذ $count أشهر';
  }

  @override
  String get yearAgo => 'منذ سنة';

  @override
  String yearsAgo(Object count) {
    return 'منذ $count سنوات';
  }

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get fieldTooShort => 'الحقل قصير جداً';

  @override
  String get fieldTooLong => 'الحقل طويل جداً';

  @override
  String get invalidEmail => 'البريد الإلكتروني غير صحيح';

  @override
  String get invalidPhone => 'رقم الهاتف غير صحيح';

  @override
  String get view => 'عرض';

  @override
  String get update => 'تحديث';

  @override
  String get remove => 'إزالة';

  @override
  String get share => 'مشاركة';

  @override
  String get download => 'تحميل';

  @override
  String get upload => 'رفع';

  @override
  String get call => 'اتصال';

  @override
  String get email => 'بريد إلكتروني';

  @override
  String get alertTypeFraud => 'احتيال مالي';

  @override
  String get alertTypeTheft => 'سرقة';

  @override
  String get alertTypeAssault => 'اعتداء';

  @override
  String get alertTypeAccident => 'حادث';

  @override
  String get alertTypeDrugs => 'مخدرات';

  @override
  String get alertTypeViolence => 'عنف';

  @override
  String get alertTypeOther => 'أخرى';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String get emptyList => 'القائمة فارغة';

  @override
  String get startCreating => 'ابدأ بإنشاء تنبيه';

  @override
  String get permissionLocation => 'الوصول إلى الموقع';

  @override
  String get permissionCamera => 'الوصول إلى الكاميرا';

  @override
  String get permissionStorage => 'الوصول إلى التخزين';

  @override
  String get permissionNotifications => 'الإشعارات';

  @override
  String get permissionRequired => 'التصريح مطلوب';

  @override
  String get permissionDenied => 'تم رفض التصريح';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get emergency => 'طوارئ';

  @override
  String get emergencyNumber => 'رقم الطوارئ';

  @override
  String get callEmergency => 'اتصل بالطوارئ';

  @override
  String get or => 'أو';

  @override
  String get welcome => 'مرحباً';

  @override
  String get passwordVeryWeak => 'ضعيفة جداً';

  @override
  String get passwordWeak => 'ضعيفة';

  @override
  String get passwordMedium => 'متوسطة';

  @override
  String get passwordStrong => 'قوية';

  @override
  String get securityQuestion1 => 'ما هو اسم أول مدرسة التحقت بها؟';

  @override
  String get securityQuestion2 => 'ما هو اسم مدينتك المفضلة؟';

  @override
  String get securityQuestion3 => 'ما هو اسم حيوانك الأليف الأول؟';

  @override
  String get securityQuestion4 => 'ما هو لقب والدتك قبل الزواج؟';

  @override
  String get securityQuestion5 => 'ما هو نوع سيارتك المفضلة؟';

  @override
  String get securityQuestion6 => 'ما هو اسم أفضل صديق في الطفولة؟';

  @override
  String get securityQuestion7 => 'ما هي وجبتك المفضلة؟';

  @override
  String get securityQuestion8 => 'في أي مدينة ولدت؟';

  @override
  String get securityQuestion9 => 'ما هو اسم جدك لأبيك؟';

  @override
  String get securityQuestion10 => 'ما هو رياضتك المفضلة؟';

  @override
  String get securityQuestion11 => 'ما هو اسم أول معلم/معلمة لك؟';

  @override
  String get securityQuestion12 => 'ما هو اسم الشارع الذي نشأت فيه؟';

  @override
  String get securityQuestion13 => 'ما هو فريقك الرياضي المفضل؟';

  @override
  String get securityQuestion14 => 'ما هو لونك المفضل؟';

  @override
  String get securityQuestion15 => 'ما هو اسم كتابك المفضل؟';

  @override
  String get aboutApp => 'حول التطبيق';

  @override
  String get aboutTitle => 'بلاغ أمان - تطبيق التبليغ عن الجرائم';

  @override
  String get aboutDescription =>
      'تطبيق مخصص للإبلاغ عن الجرائم والحوادث بشكل فوري وآمن مع خاصية تحديد الموقع الجغرافي الدقيق';

  @override
  String get aboutResearchers => 'الباحثات';

  @override
  String get aboutInstitution => 'الجهة';

  @override
  String get aboutDevelopers => 'المبرمجون';

  @override
  String get aboutVersion => 'الإصدار';

  @override
  String get aboutContact => 'للتواصل';

  @override
  String get researcher1 => 'مريم بن سعيد';

  @override
  String get researcher2 => 'الصولي فاطمة';

  @override
  String get institution => 'معهد علم الإجرام - جامعة أحمد بن بلة 1';

  @override
  String get developer1 => 'مراد غربي';

  @override
  String get developer2 => 'منديل أحمد عبد الحفيظ';

  @override
  String get developer1Email => 'mourad.gharbi31@gmail.com';

  @override
  String get developer2Email => 'hafidmendil349@gmail.com';

  @override
  String get developer1Phone => '0799311955';

  @override
  String get developer1Address => 'أرزيو، المحقن';

  @override
  String get developer1Location =>
      'https://www.google.com/maps/search/?api=1&query=Arzew,El+Mohgon';

  @override
  String get developer2Phone => '0674932125';

  @override
  String get developer2Address => 'معسكر، وادي التاغية';

  @override
  String get developer2Location =>
      'https://www.google.com/maps/search/?api=1&query=Mascara,Oued+Taria';

  @override
  String get appFeatures => 'مميزات التطبيق';

  @override
  String get feature1 => 'تحديد الموقع الجغرافي الدقيق';

  @override
  String get feature2 => 'إرفاق الصور والأدلة';

  @override
  String get feature3 => 'التواصل المباشر مع الإدارة';

  @override
  String get feature4 => 'متابعة حالة البلاغات';

  @override
  String get feature5 => 'واجهة عربية/إنجليزية';

  @override
  String get projectInfo => 'معلومات المشروع';

  @override
  String get realizedBy => 'أنجز من طرف';

  @override
  String get programmedBy => 'برمج من طرف';

  @override
  String get viewProfile => 'عرض الملف الشخصي';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get accountInfo => 'معلومات الحساب';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get buildNumber => 'رقم البناء';

  @override
  String get all => 'الكل';

  @override
  String get userFeedbacks => 'ملاحظات المستخدمين';

  @override
  String countFeedbacks(Object count) {
    return '$count ملاحظة';
  }

  @override
  String get replyHint => 'اكتب ردك هنا...';

  @override
  String get filterByStatus => 'تصفية حسب الحالة';

  @override
  String get blockUser => 'حظر المستخدم';

  @override
  String get unblockUser => 'إلغاء الحظر';

  @override
  String get sendWarning => 'إرسال تحذير';

  @override
  String get userBlocked => 'تم حظر المستخدم';

  @override
  String get userUnblocked => 'تم إلغاء حظر المستخدم';

  @override
  String get warningSent => 'تم إرسال التحذير بنجاح';

  @override
  String get blockConfirm =>
      'هل أنت متأكد من حظر هذا المستخدم؟ لن يتمكن من تسجيل الدخول أو إرسال بلاغات.';

  @override
  String get unblockConfirm => 'هل أنت متأكد من إلغاء حظر هذا المستخدم؟';

  @override
  String get warningTitle => 'تحذير من الإدارة';

  @override
  String get warningMessage => 'رسالة التحذير';

  @override
  String get warningHint => 'اكتب سبب التحذير هنا...';

  @override
  String get errorBlockedAccount => 'تم حظر حسابك. يرجى الاتصال بالإدارة.';

  @override
  String get statusActive => 'نشط';

  @override
  String get statusBlocked => 'محظور';

  @override
  String get addFiles => 'إضافة ملفات';

  @override
  String get alertFiles => 'الملفات المرفقة';

  @override
  String get selectFiles => 'اختر ملفات';

  @override
  String get errorNoFiles => 'لم يتم اختيار أي ملف';

  @override
  String get openFile => 'فتح الملف';
}
