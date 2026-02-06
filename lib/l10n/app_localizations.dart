import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'بلاغ أمان'**
  String get appTitle;

  /// No description provided for @appDescription.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق التبليغ عن الجرائم والحوادث'**
  String get appDescription;

  /// No description provided for @yes.
  ///
  /// In ar, this message translates to:
  /// **'نعم'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In ar, this message translates to:
  /// **'لا'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In ar, this message translates to:
  /// **'حسناً'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @close.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get close;

  /// No description provided for @back.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get back;

  /// No description provided for @next.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In ar, this message translates to:
  /// **'السابق'**
  String get previous;

  /// No description provided for @submit.
  ///
  /// In ar, this message translates to:
  /// **'إرسال'**
  String get submit;

  /// No description provided for @confirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get confirm;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In ar, this message translates to:
  /// **'تصفية'**
  String get filter;

  /// No description provided for @refresh.
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get refresh;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحميل...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In ar, this message translates to:
  /// **'خطأ'**
  String get error;

  /// No description provided for @success.
  ///
  /// In ar, this message translates to:
  /// **'نجاح'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In ar, this message translates to:
  /// **'تحذير'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In ar, this message translates to:
  /// **'معلومات'**
  String get info;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @register.
  ///
  /// In ar, this message translates to:
  /// **'التسجيل'**
  String get register;

  /// No description provided for @phoneNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phoneNumber;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تعيين كلمة المرور'**
  String get resetPassword;

  /// No description provided for @firstName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In ar, this message translates to:
  /// **'اللقب'**
  String get lastName;

  /// No description provided for @nationalCard.
  ///
  /// In ar, this message translates to:
  /// **'رقم البطاقة الوطنية'**
  String get nationalCard;

  /// No description provided for @securityQuestions.
  ///
  /// In ar, this message translates to:
  /// **'الأسئلة الأمنية'**
  String get securityQuestions;

  /// No description provided for @answer.
  ///
  /// In ar, this message translates to:
  /// **'الإجابة'**
  String get answer;

  /// No description provided for @loginWelcome.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بعودتك'**
  String get loginWelcome;

  /// No description provided for @loginSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'سجل دخولك للمتابعة'**
  String get loginSubtitle;

  /// No description provided for @registerWelcome.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب جديد'**
  String get registerWelcome;

  /// No description provided for @registerSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'انضم إلينا للإبلاغ عن الجرائم'**
  String get registerSubtitle;

  /// No description provided for @phoneHint.
  ///
  /// In ar, this message translates to:
  /// **'05xxxxxxxx'**
  String get phoneHint;

  /// No description provided for @passwordHint.
  ///
  /// In ar, this message translates to:
  /// **'على الأقل 6 أحرف'**
  String get passwordHint;

  /// No description provided for @firstNameHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسمك'**
  String get firstNameHint;

  /// No description provided for @lastNameHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل لقبك'**
  String get lastNameHint;

  /// No description provided for @nationalCardHint.
  ///
  /// In ar, this message translates to:
  /// **'18 رقماً'**
  String get nationalCardHint;

  /// No description provided for @errorInvalidPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف غير صحيح'**
  String get errorInvalidPhone;

  /// No description provided for @errorInvalidPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور يجب أن تحتوي على 6 أحرف على الأقل'**
  String get errorInvalidPassword;

  /// No description provided for @errorPasswordMismatch.
  ///
  /// In ar, this message translates to:
  /// **'كلمات المرور غير متطابقة'**
  String get errorPasswordMismatch;

  /// No description provided for @errorInvalidNationalCard.
  ///
  /// In ar, this message translates to:
  /// **'رقم البطاقة الوطنية غير صحيح (18 رقماً)'**
  String get errorInvalidNationalCard;

  /// No description provided for @errorLoginFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل تسجيل الدخول'**
  String get errorLoginFailed;

  /// No description provided for @errorRegisterFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل التسجيل'**
  String get errorRegisterFailed;

  /// No description provided for @errorUserNotFound.
  ///
  /// In ar, this message translates to:
  /// **'المستخدم غير موجود'**
  String get errorUserNotFound;

  /// No description provided for @errorWrongPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور خاطئة'**
  String get errorWrongPassword;

  /// No description provided for @successLogin.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الدخول بنجاح'**
  String get successLogin;

  /// No description provided for @successRegister.
  ///
  /// In ar, this message translates to:
  /// **'تم التسجيل بنجاح'**
  String get successRegister;

  /// No description provided for @successLogout.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الخروج'**
  String get successLogout;

  /// No description provided for @navHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get navHome;

  /// No description provided for @navAlerts.
  ///
  /// In ar, this message translates to:
  /// **'التنبيهات'**
  String get navAlerts;

  /// No description provided for @navMap.
  ///
  /// In ar, this message translates to:
  /// **'الخريطة'**
  String get navMap;

  /// No description provided for @navProfile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get navProfile;

  /// No description provided for @navSettings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get navSettings;

  /// No description provided for @navDashboard.
  ///
  /// In ar, this message translates to:
  /// **'لوحة التحكم'**
  String get navDashboard;

  /// No description provided for @navUsers.
  ///
  /// In ar, this message translates to:
  /// **'المستخدمون'**
  String get navUsers;

  /// No description provided for @navFeedback.
  ///
  /// In ar, this message translates to:
  /// **'الملاحظات'**
  String get navFeedback;

  /// No description provided for @alerts.
  ///
  /// In ar, this message translates to:
  /// **'التنبيهات'**
  String get alerts;

  /// No description provided for @myAlerts.
  ///
  /// In ar, this message translates to:
  /// **'تنبيهاتي'**
  String get myAlerts;

  /// No description provided for @createAlert.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء تنبيه'**
  String get createAlert;

  /// No description provided for @alertDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل التنبيه'**
  String get alertDetails;

  /// No description provided for @alertType.
  ///
  /// In ar, this message translates to:
  /// **'نوع التنبيه'**
  String get alertType;

  /// No description provided for @alertDescription.
  ///
  /// In ar, this message translates to:
  /// **'وصف التنبيه'**
  String get alertDescription;

  /// No description provided for @alertLocation.
  ///
  /// In ar, this message translates to:
  /// **'الموقع'**
  String get alertLocation;

  /// No description provided for @alertPhotos.
  ///
  /// In ar, this message translates to:
  /// **'الصور'**
  String get alertPhotos;

  /// No description provided for @alertStatus.
  ///
  /// In ar, this message translates to:
  /// **'الحالة'**
  String get alertStatus;

  /// No description provided for @alertDate.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ'**
  String get alertDate;

  /// No description provided for @alertTime.
  ///
  /// In ar, this message translates to:
  /// **'الوقت'**
  String get alertTime;

  /// No description provided for @statusPending.
  ///
  /// In ar, this message translates to:
  /// **'قيد الانتظار'**
  String get statusPending;

  /// No description provided for @statusInProgress.
  ///
  /// In ar, this message translates to:
  /// **'قيد المعالجة'**
  String get statusInProgress;

  /// No description provided for @statusResolved.
  ///
  /// In ar, this message translates to:
  /// **'تم الحل'**
  String get statusResolved;

  /// No description provided for @selectAlertType.
  ///
  /// In ar, this message translates to:
  /// **'اختر نوع التنبيه'**
  String get selectAlertType;

  /// No description provided for @describeAlert.
  ///
  /// In ar, this message translates to:
  /// **'صف المشكلة بالتفصيل...'**
  String get describeAlert;

  /// No description provided for @addPhotos.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صور'**
  String get addPhotos;

  /// No description provided for @takePhoto.
  ///
  /// In ar, this message translates to:
  /// **'التقاط صورة'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In ar, this message translates to:
  /// **'اختر من المعرض'**
  String get chooseFromGallery;

  /// No description provided for @locationAccuracy.
  ///
  /// In ar, this message translates to:
  /// **'دقة الموقع'**
  String get locationAccuracy;

  /// No description provided for @errorNoType.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار نوع التنبيه'**
  String get errorNoType;

  /// No description provided for @errorNoDescription.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء وصف المشكلة'**
  String get errorNoDescription;

  /// No description provided for @errorNoLocation.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن الحصول على موقعك'**
  String get errorNoLocation;

  /// No description provided for @errorLocationPermission.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء السماح بالوصول إلى الموقع'**
  String get errorLocationPermission;

  /// No description provided for @successAlertCreated.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء التنبيه بنجاح'**
  String get successAlertCreated;

  /// No description provided for @successAlertUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث التنبيه'**
  String get successAlertUpdated;

  /// No description provided for @successAlertDeleted.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف التنبيه'**
  String get successAlertDeleted;

  /// No description provided for @confirmDeleteAlert.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف هذا التنبيه؟'**
  String get confirmDeleteAlert;

  /// No description provided for @noAlerts.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تنبيهات'**
  String get noAlerts;

  /// No description provided for @noAlertsFiltered.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تنبيهات بهذه الحالة'**
  String get noAlertsFiltered;

  /// No description provided for @messages.
  ///
  /// In ar, this message translates to:
  /// **'الرسائل'**
  String get messages;

  /// No description provided for @sendMessage.
  ///
  /// In ar, this message translates to:
  /// **'إرسال رسالة'**
  String get sendMessage;

  /// No description provided for @typeMessage.
  ///
  /// In ar, this message translates to:
  /// **'اكتب رسالة...'**
  String get typeMessage;

  /// No description provided for @noMessages.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد رسائل'**
  String get noMessages;

  /// No description provided for @messageFrom.
  ///
  /// In ar, this message translates to:
  /// **'من'**
  String get messageFrom;

  /// No description provided for @messageTo.
  ///
  /// In ar, this message translates to:
  /// **'إلى'**
  String get messageTo;

  /// No description provided for @admin.
  ///
  /// In ar, this message translates to:
  /// **'المدير'**
  String get admin;

  /// No description provided for @user.
  ///
  /// In ar, this message translates to:
  /// **'المستخدم'**
  String get user;

  /// No description provided for @successMessageSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال الرسالة'**
  String get successMessageSent;

  /// No description provided for @errorMessageFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل إرسال الرسالة'**
  String get errorMessageFailed;

  /// No description provided for @map.
  ///
  /// In ar, this message translates to:
  /// **'الخريطة'**
  String get map;

  /// No description provided for @showOnMap.
  ///
  /// In ar, this message translates to:
  /// **'عرض على الخريطة'**
  String get showOnMap;

  /// No description provided for @myLocation.
  ///
  /// In ar, this message translates to:
  /// **'موقعي'**
  String get myLocation;

  /// No description provided for @alertsOnMap.
  ///
  /// In ar, this message translates to:
  /// **'التنبيهات على الخريطة'**
  String get alertsOnMap;

  /// No description provided for @gpsExcellent.
  ///
  /// In ar, this message translates to:
  /// **'ممتازة'**
  String get gpsExcellent;

  /// No description provided for @gpsGood.
  ///
  /// In ar, this message translates to:
  /// **'جيدة'**
  String get gpsGood;

  /// No description provided for @gpsAverage.
  ///
  /// In ar, this message translates to:
  /// **'متوسطة'**
  String get gpsAverage;

  /// No description provided for @gpsPoor.
  ///
  /// In ar, this message translates to:
  /// **'ضعيفة'**
  String get gpsPoor;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @accountSettings.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الحساب'**
  String get accountSettings;

  /// No description provided for @appSettings.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات التطبيق'**
  String get appSettings;

  /// No description provided for @theme.
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifications;

  /// No description provided for @about.
  ///
  /// In ar, this message translates to:
  /// **'حول'**
  String get about;

  /// No description provided for @help.
  ///
  /// In ar, this message translates to:
  /// **'مساعدة'**
  String get help;

  /// No description provided for @privacy.
  ///
  /// In ar, this message translates to:
  /// **'الخصوصية'**
  String get privacy;

  /// No description provided for @terms.
  ///
  /// In ar, this message translates to:
  /// **'الشروط'**
  String get terms;

  /// No description provided for @themeLight.
  ///
  /// In ar, this message translates to:
  /// **'فاتح'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In ar, this message translates to:
  /// **'داكن'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In ar, this message translates to:
  /// **'تلقائي (النظام)'**
  String get themeSystem;

  /// No description provided for @languageArabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @notificationsEnabled.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل الإشعارات'**
  String get notificationsEnabled;

  /// No description provided for @notificationsAlerts.
  ///
  /// In ar, this message translates to:
  /// **'إشعارات التنبيهات'**
  String get notificationsAlerts;

  /// No description provided for @notificationsMessages.
  ///
  /// In ar, this message translates to:
  /// **'إشعارات الرسائل'**
  String get notificationsMessages;

  /// No description provided for @notificationsStatus.
  ///
  /// In ar, this message translates to:
  /// **'إشعارات تغيير الحالة'**
  String get notificationsStatus;

  /// No description provided for @feedback.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظاتك'**
  String get feedback;

  /// No description provided for @sendFeedback.
  ///
  /// In ar, this message translates to:
  /// **'إرسال ملاحظة'**
  String get sendFeedback;

  /// No description provided for @feedbackMessage.
  ///
  /// In ar, this message translates to:
  /// **'اكتب ملاحظتك أو اقتراحك...'**
  String get feedbackMessage;

  /// No description provided for @feedbackPlaceholder.
  ///
  /// In ar, this message translates to:
  /// **'شاركنا رأيك لتحسين التطبيق'**
  String get feedbackPlaceholder;

  /// No description provided for @rateApp.
  ///
  /// In ar, this message translates to:
  /// **'قيّم التطبيق'**
  String get rateApp;

  /// No description provided for @myFeedback.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظاتي'**
  String get myFeedback;

  /// No description provided for @adminReply.
  ///
  /// In ar, this message translates to:
  /// **'رد الإدارة'**
  String get adminReply;

  /// No description provided for @noFeedback.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد ملاحظات'**
  String get noFeedback;

  /// No description provided for @feedbackStatusPending.
  ///
  /// In ar, this message translates to:
  /// **'قيد الانتظار'**
  String get feedbackStatusPending;

  /// No description provided for @feedbackStatusRead.
  ///
  /// In ar, this message translates to:
  /// **'تمت القراءة'**
  String get feedbackStatusRead;

  /// No description provided for @feedbackStatusReplied.
  ///
  /// In ar, this message translates to:
  /// **'تم الرد'**
  String get feedbackStatusReplied;

  /// No description provided for @successFeedbackSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال ملاحظتك بنجاح'**
  String get successFeedbackSent;

  /// No description provided for @errorFeedbackTooShort.
  ///
  /// In ar, this message translates to:
  /// **'الرسالة يجب أن تحتوي على 10 أحرف على الأقل'**
  String get errorFeedbackTooShort;

  /// No description provided for @errorNoRating.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إعطاء تقييم'**
  String get errorNoRating;

  /// No description provided for @adminPanel.
  ///
  /// In ar, this message translates to:
  /// **'لوحة الإدارة'**
  String get adminPanel;

  /// No description provided for @adminDashboard.
  ///
  /// In ar, this message translates to:
  /// **'لوحة التحكم'**
  String get adminDashboard;

  /// No description provided for @totalAlerts.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي التنبيهات'**
  String get totalAlerts;

  /// No description provided for @totalUsers.
  ///
  /// In ar, this message translates to:
  /// **'المستخدمون'**
  String get totalUsers;

  /// No description provided for @pendingAlerts.
  ///
  /// In ar, this message translates to:
  /// **'قيد الانتظار'**
  String get pendingAlerts;

  /// No description provided for @inProgressAlerts.
  ///
  /// In ar, this message translates to:
  /// **'قيد المعالجة'**
  String get inProgressAlerts;

  /// No description provided for @resolvedAlerts.
  ///
  /// In ar, this message translates to:
  /// **'تم الحل'**
  String get resolvedAlerts;

  /// No description provided for @changeStatus.
  ///
  /// In ar, this message translates to:
  /// **'تغيير الحالة'**
  String get changeStatus;

  /// No description provided for @replyToFeedback.
  ///
  /// In ar, this message translates to:
  /// **'الرد على الملاحظة'**
  String get replyToFeedback;

  /// No description provided for @yourReply.
  ///
  /// In ar, this message translates to:
  /// **'ردك'**
  String get yourReply;

  /// No description provided for @userDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل المستخدم'**
  String get userDetails;

  /// No description provided for @userFullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get userFullName;

  /// No description provided for @userPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get userPhone;

  /// No description provided for @userNationalCard.
  ///
  /// In ar, this message translates to:
  /// **'رقم البطاقة الوطنية'**
  String get userNationalCard;

  /// No description provided for @userAlertsCount.
  ///
  /// In ar, this message translates to:
  /// **'عدد التنبيهات'**
  String get userAlertsCount;

  /// No description provided for @successStatusChanged.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث الحالة'**
  String get successStatusChanged;

  /// No description provided for @successReplyAdded.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال الرد بنجاح'**
  String get successReplyAdded;

  /// No description provided for @statistics.
  ///
  /// In ar, this message translates to:
  /// **'الإحصائيات'**
  String get statistics;

  /// No description provided for @today.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In ar, this message translates to:
  /// **'هذا الأسبوع'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In ar, this message translates to:
  /// **'هذا الشهر'**
  String get thisMonth;

  /// No description provided for @allTime.
  ///
  /// In ar, this message translates to:
  /// **'كل الوقت'**
  String get allTime;

  /// No description provided for @justNow.
  ///
  /// In ar, this message translates to:
  /// **'الآن'**
  String get justNow;

  /// No description provided for @minuteAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ دقيقة'**
  String get minuteAgo;

  /// No description provided for @minutesAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ {count} دقائق'**
  String minutesAgo(Object count);

  /// No description provided for @hourAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ ساعة'**
  String get hourAgo;

  /// No description provided for @hoursAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ {count} ساعات'**
  String hoursAgo(Object count);

  /// No description provided for @dayAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ يوم'**
  String get dayAgo;

  /// No description provided for @daysAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ {count} أيام'**
  String daysAgo(Object count);

  /// No description provided for @weekAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ أسبوع'**
  String get weekAgo;

  /// No description provided for @weeksAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ {count} أسابيع'**
  String weeksAgo(Object count);

  /// No description provided for @monthAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ شهر'**
  String get monthAgo;

  /// No description provided for @monthsAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ {count} أشهر'**
  String monthsAgo(Object count);

  /// No description provided for @yearAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ سنة'**
  String get yearAgo;

  /// No description provided for @yearsAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ {count} سنوات'**
  String yearsAgo(Object count);

  /// No description provided for @fieldRequired.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get fieldRequired;

  /// No description provided for @fieldTooShort.
  ///
  /// In ar, this message translates to:
  /// **'الحقل قصير جداً'**
  String get fieldTooShort;

  /// No description provided for @fieldTooLong.
  ///
  /// In ar, this message translates to:
  /// **'الحقل طويل جداً'**
  String get fieldTooLong;

  /// No description provided for @invalidEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني غير صحيح'**
  String get invalidEmail;

  /// No description provided for @invalidPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف غير صحيح'**
  String get invalidPhone;

  /// No description provided for @view.
  ///
  /// In ar, this message translates to:
  /// **'عرض'**
  String get view;

  /// No description provided for @update.
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get update;

  /// No description provided for @remove.
  ///
  /// In ar, this message translates to:
  /// **'إزالة'**
  String get remove;

  /// No description provided for @share.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة'**
  String get share;

  /// No description provided for @download.
  ///
  /// In ar, this message translates to:
  /// **'تحميل'**
  String get download;

  /// No description provided for @upload.
  ///
  /// In ar, this message translates to:
  /// **'رفع'**
  String get upload;

  /// No description provided for @call.
  ///
  /// In ar, this message translates to:
  /// **'اتصال'**
  String get call;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'بريد إلكتروني'**
  String get email;

  /// No description provided for @alertTypeFraud.
  ///
  /// In ar, this message translates to:
  /// **'احتيال مالي'**
  String get alertTypeFraud;

  /// No description provided for @alertTypeTheft.
  ///
  /// In ar, this message translates to:
  /// **'سرقة'**
  String get alertTypeTheft;

  /// No description provided for @alertTypeAssault.
  ///
  /// In ar, this message translates to:
  /// **'اعتداء'**
  String get alertTypeAssault;

  /// No description provided for @alertTypeAccident.
  ///
  /// In ar, this message translates to:
  /// **'حادث'**
  String get alertTypeAccident;

  /// No description provided for @alertTypeDrugs.
  ///
  /// In ar, this message translates to:
  /// **'مخدرات'**
  String get alertTypeDrugs;

  /// No description provided for @alertTypeViolence.
  ///
  /// In ar, this message translates to:
  /// **'عنف'**
  String get alertTypeViolence;

  /// No description provided for @alertTypeOther.
  ///
  /// In ar, this message translates to:
  /// **'أخرى'**
  String get alertTypeOther;

  /// No description provided for @noData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات'**
  String get noData;

  /// No description provided for @noResults.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج'**
  String get noResults;

  /// No description provided for @emptyList.
  ///
  /// In ar, this message translates to:
  /// **'القائمة فارغة'**
  String get emptyList;

  /// No description provided for @startCreating.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ بإنشاء تنبيه'**
  String get startCreating;

  /// No description provided for @permissionLocation.
  ///
  /// In ar, this message translates to:
  /// **'الوصول إلى الموقع'**
  String get permissionLocation;

  /// No description provided for @permissionCamera.
  ///
  /// In ar, this message translates to:
  /// **'الوصول إلى الكاميرا'**
  String get permissionCamera;

  /// No description provided for @permissionStorage.
  ///
  /// In ar, this message translates to:
  /// **'الوصول إلى التخزين'**
  String get permissionStorage;

  /// No description provided for @permissionNotifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get permissionNotifications;

  /// No description provided for @permissionRequired.
  ///
  /// In ar, this message translates to:
  /// **'التصريح مطلوب'**
  String get permissionRequired;

  /// No description provided for @permissionDenied.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض التصريح'**
  String get permissionDenied;

  /// No description provided for @openSettings.
  ///
  /// In ar, this message translates to:
  /// **'فتح الإعدادات'**
  String get openSettings;

  /// No description provided for @emergency.
  ///
  /// In ar, this message translates to:
  /// **'طوارئ'**
  String get emergency;

  /// No description provided for @emergencyNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الطوارئ'**
  String get emergencyNumber;

  /// No description provided for @callEmergency.
  ///
  /// In ar, this message translates to:
  /// **'اتصل بالطوارئ'**
  String get callEmergency;

  /// No description provided for @or.
  ///
  /// In ar, this message translates to:
  /// **'أو'**
  String get or;

  /// No description provided for @welcome.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً'**
  String get welcome;

  /// No description provided for @passwordVeryWeak.
  ///
  /// In ar, this message translates to:
  /// **'ضعيفة جداً'**
  String get passwordVeryWeak;

  /// No description provided for @passwordWeak.
  ///
  /// In ar, this message translates to:
  /// **'ضعيفة'**
  String get passwordWeak;

  /// No description provided for @passwordMedium.
  ///
  /// In ar, this message translates to:
  /// **'متوسطة'**
  String get passwordMedium;

  /// No description provided for @passwordStrong.
  ///
  /// In ar, this message translates to:
  /// **'قوية'**
  String get passwordStrong;

  /// No description provided for @securityQuestion1.
  ///
  /// In ar, this message translates to:
  /// **'ما هو اسم أول مدرسة التحقت بها؟'**
  String get securityQuestion1;

  /// No description provided for @securityQuestion2.
  ///
  /// In ar, this message translates to:
  /// **'ما هو اسم مدينتك المفضلة؟'**
  String get securityQuestion2;

  /// No description provided for @securityQuestion3.
  ///
  /// In ar, this message translates to:
  /// **'ما هو اسم حيوانك الأليف الأول؟'**
  String get securityQuestion3;

  /// No description provided for @securityQuestion4.
  ///
  /// In ar, this message translates to:
  /// **'ما هو لقب والدتك قبل الزواج؟'**
  String get securityQuestion4;

  /// No description provided for @securityQuestion5.
  ///
  /// In ar, this message translates to:
  /// **'ما هو نوع سيارتك المفضلة؟'**
  String get securityQuestion5;

  /// No description provided for @securityQuestion6.
  ///
  /// In ar, this message translates to:
  /// **'ما هو اسم أفضل صديق في الطفولة؟'**
  String get securityQuestion6;

  /// No description provided for @securityQuestion7.
  ///
  /// In ar, this message translates to:
  /// **'ما هي وجبتك المفضلة؟'**
  String get securityQuestion7;

  /// No description provided for @securityQuestion8.
  ///
  /// In ar, this message translates to:
  /// **'في أي مدينة ولدت؟'**
  String get securityQuestion8;

  /// No description provided for @securityQuestion9.
  ///
  /// In ar, this message translates to:
  /// **'ما هو اسم جدك لأبيك؟'**
  String get securityQuestion9;

  /// No description provided for @securityQuestion10.
  ///
  /// In ar, this message translates to:
  /// **'ما هو رياضتك المفضلة؟'**
  String get securityQuestion10;

  /// No description provided for @securityQuestion11.
  ///
  /// In ar, this message translates to:
  /// **'ما هو اسم أول معلم/معلمة لك؟'**
  String get securityQuestion11;

  /// No description provided for @securityQuestion12.
  ///
  /// In ar, this message translates to:
  /// **'ما هو اسم الشارع الذي نشأت فيه؟'**
  String get securityQuestion12;

  /// No description provided for @securityQuestion13.
  ///
  /// In ar, this message translates to:
  /// **'ما هو فريقك الرياضي المفضل؟'**
  String get securityQuestion13;

  /// No description provided for @securityQuestion14.
  ///
  /// In ar, this message translates to:
  /// **'ما هو لونك المفضل؟'**
  String get securityQuestion14;

  /// No description provided for @securityQuestion15.
  ///
  /// In ar, this message translates to:
  /// **'ما هو اسم كتابك المفضل؟'**
  String get securityQuestion15;

  /// No description provided for @aboutApp.
  ///
  /// In ar, this message translates to:
  /// **'حول التطبيق'**
  String get aboutApp;

  /// No description provided for @aboutTitle.
  ///
  /// In ar, this message translates to:
  /// **'بلاغ أمان - تطبيق التبليغ عن الجرائم'**
  String get aboutTitle;

  /// No description provided for @aboutDescription.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق مخصص للإبلاغ عن الجرائم والحوادث بشكل فوري وآمن مع خاصية تحديد الموقع الجغرافي الدقيق'**
  String get aboutDescription;

  /// No description provided for @aboutResearchers.
  ///
  /// In ar, this message translates to:
  /// **'الباحثات'**
  String get aboutResearchers;

  /// No description provided for @aboutInstitution.
  ///
  /// In ar, this message translates to:
  /// **'الجهة'**
  String get aboutInstitution;

  /// No description provided for @aboutDevelopers.
  ///
  /// In ar, this message translates to:
  /// **'المبرمجون'**
  String get aboutDevelopers;

  /// No description provided for @aboutVersion.
  ///
  /// In ar, this message translates to:
  /// **'الإصدار'**
  String get aboutVersion;

  /// No description provided for @aboutContact.
  ///
  /// In ar, this message translates to:
  /// **'للتواصل'**
  String get aboutContact;

  /// No description provided for @researcher1.
  ///
  /// In ar, this message translates to:
  /// **'مريم بن سعيد'**
  String get researcher1;

  /// No description provided for @researcher2.
  ///
  /// In ar, this message translates to:
  /// **'الصولي فاطمة'**
  String get researcher2;

  /// No description provided for @institution.
  ///
  /// In ar, this message translates to:
  /// **'معهد علم الإجرام - جامعة أحمد بن بلة 1'**
  String get institution;

  /// No description provided for @developer1.
  ///
  /// In ar, this message translates to:
  /// **'مراد غربي'**
  String get developer1;

  /// No description provided for @developer2.
  ///
  /// In ar, this message translates to:
  /// **'منديل أحمد عبد الحفيظ'**
  String get developer2;

  /// No description provided for @developer1Email.
  ///
  /// In ar, this message translates to:
  /// **'mourad.gharbi31@gmail.com'**
  String get developer1Email;

  /// No description provided for @developer2Email.
  ///
  /// In ar, this message translates to:
  /// **'hafidmendil349@gmail.com'**
  String get developer2Email;

  /// No description provided for @developer1Phone.
  ///
  /// In ar, this message translates to:
  /// **'0799311955'**
  String get developer1Phone;

  /// No description provided for @developer1Address.
  ///
  /// In ar, this message translates to:
  /// **'أرزيو، المحقن'**
  String get developer1Address;

  /// No description provided for @developer1Location.
  ///
  /// In ar, this message translates to:
  /// **'https://www.google.com/maps/search/?api=1&query=Arzew,El+Mohgon'**
  String get developer1Location;

  /// No description provided for @developer2Phone.
  ///
  /// In ar, this message translates to:
  /// **'0674932125'**
  String get developer2Phone;

  /// No description provided for @developer2Address.
  ///
  /// In ar, this message translates to:
  /// **'معسكر، وادي التاغية'**
  String get developer2Address;

  /// No description provided for @developer2Location.
  ///
  /// In ar, this message translates to:
  /// **'https://www.google.com/maps/search/?api=1&query=Mascara,Oued+Taria'**
  String get developer2Location;

  /// No description provided for @appFeatures.
  ///
  /// In ar, this message translates to:
  /// **'مميزات التطبيق'**
  String get appFeatures;

  /// No description provided for @feature1.
  ///
  /// In ar, this message translates to:
  /// **'تحديد الموقع الجغرافي الدقيق'**
  String get feature1;

  /// No description provided for @feature2.
  ///
  /// In ar, this message translates to:
  /// **'إرفاق الصور والأدلة'**
  String get feature2;

  /// No description provided for @feature3.
  ///
  /// In ar, this message translates to:
  /// **'التواصل المباشر مع الإدارة'**
  String get feature3;

  /// No description provided for @feature4.
  ///
  /// In ar, this message translates to:
  /// **'متابعة حالة البلاغات'**
  String get feature4;

  /// No description provided for @feature5.
  ///
  /// In ar, this message translates to:
  /// **'واجهة عربية/إنجليزية'**
  String get feature5;

  /// No description provided for @projectInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات المشروع'**
  String get projectInfo;

  /// No description provided for @realizedBy.
  ///
  /// In ar, this message translates to:
  /// **'أنجز من طرف'**
  String get realizedBy;

  /// No description provided for @programmedBy.
  ///
  /// In ar, this message translates to:
  /// **'برمج من طرف'**
  String get programmedBy;

  /// No description provided for @viewProfile.
  ///
  /// In ar, this message translates to:
  /// **'عرض الملف الشخصي'**
  String get viewProfile;

  /// No description provided for @editProfile.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الملف الشخصي'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In ar, this message translates to:
  /// **'تغيير كلمة المرور'**
  String get changePassword;

  /// No description provided for @accountInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات الحساب'**
  String get accountInfo;

  /// No description provided for @appVersion.
  ///
  /// In ar, this message translates to:
  /// **'إصدار التطبيق'**
  String get appVersion;

  /// No description provided for @buildNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم البناء'**
  String get buildNumber;

  /// No description provided for @all.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get all;

  /// No description provided for @userFeedbacks.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات المستخدمين'**
  String get userFeedbacks;

  /// No description provided for @countFeedbacks.
  ///
  /// In ar, this message translates to:
  /// **'{count} ملاحظة'**
  String countFeedbacks(Object count);

  /// No description provided for @replyHint.
  ///
  /// In ar, this message translates to:
  /// **'اكتب ردك هنا...'**
  String get replyHint;

  /// No description provided for @filterByStatus.
  ///
  /// In ar, this message translates to:
  /// **'تصفية حسب الحالة'**
  String get filterByStatus;

  /// No description provided for @blockUser.
  ///
  /// In ar, this message translates to:
  /// **'حظر المستخدم'**
  String get blockUser;

  /// No description provided for @unblockUser.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الحظر'**
  String get unblockUser;

  /// No description provided for @sendWarning.
  ///
  /// In ar, this message translates to:
  /// **'إرسال تحذير'**
  String get sendWarning;

  /// No description provided for @userBlocked.
  ///
  /// In ar, this message translates to:
  /// **'تم حظر المستخدم'**
  String get userBlocked;

  /// No description provided for @userUnblocked.
  ///
  /// In ar, this message translates to:
  /// **'تم إلغاء حظر المستخدم'**
  String get userUnblocked;

  /// No description provided for @warningSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال التحذير بنجاح'**
  String get warningSent;

  /// No description provided for @blockConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حظر هذا المستخدم؟ لن يتمكن من تسجيل الدخول أو إرسال بلاغات.'**
  String get blockConfirm;

  /// No description provided for @unblockConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من إلغاء حظر هذا المستخدم؟'**
  String get unblockConfirm;

  /// No description provided for @warningTitle.
  ///
  /// In ar, this message translates to:
  /// **'تحذير من الإدارة'**
  String get warningTitle;

  /// No description provided for @warningMessage.
  ///
  /// In ar, this message translates to:
  /// **'رسالة التحذير'**
  String get warningMessage;

  /// No description provided for @warningHint.
  ///
  /// In ar, this message translates to:
  /// **'اكتب سبب التحذير هنا...'**
  String get warningHint;

  /// No description provided for @errorBlockedAccount.
  ///
  /// In ar, this message translates to:
  /// **'تم حظر حسابك. يرجى الاتصال بالإدارة.'**
  String get errorBlockedAccount;

  /// No description provided for @statusActive.
  ///
  /// In ar, this message translates to:
  /// **'نشط'**
  String get statusActive;

  /// No description provided for @statusBlocked.
  ///
  /// In ar, this message translates to:
  /// **'محظور'**
  String get statusBlocked;

  /// No description provided for @addFiles.
  ///
  /// In ar, this message translates to:
  /// **'إضافة ملفات'**
  String get addFiles;

  /// No description provided for @alertFiles.
  ///
  /// In ar, this message translates to:
  /// **'الملفات المرفقة'**
  String get alertFiles;

  /// No description provided for @selectFiles.
  ///
  /// In ar, this message translates to:
  /// **'اختر ملفات'**
  String get selectFiles;

  /// No description provided for @errorNoFiles.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم اختيار أي ملف'**
  String get errorNoFiles;

  /// No description provided for @openFile.
  ///
  /// In ar, this message translates to:
  /// **'فتح الملف'**
  String get openFile;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
