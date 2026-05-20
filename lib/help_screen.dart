import 'package:flutter/material.dart';
import 'context_extensions.dart';
import 'utils.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animations = List.generate(10, (index) {
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(
          (index * 0.1).clamp(0.0, 1.0),
          ((index * 0.1) + 0.3).clamp(0.0, 1.0),
          curve: Curves.easeOut,
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.isArabic;
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150.0,
            floating: false,
            pinned: true,
            iconTheme: IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                context.l10n.help,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [context.colors.brand, context.colors.brand.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(Icons.help_center, size: 120, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAnimatedSection(0, _buildHeader(context)),
                    const SizedBox(height: 32),
                    
                    _buildAnimatedSection(1, _buildSectionTitle(context, isAr ? 'دليل الاستخدام السريع' : 'Quick Start Guide')),
                    _buildAnimatedSection(2, _buildStepGuide(context, isAr)),
                    
                    const SizedBox(height: 32),
                    _buildAnimatedSection(3, _buildSectionTitle(context, isAr ? 'الأسئلة الشائعة' : 'Frequently Asked Questions')),
                    
                    _buildAnimatedSection(4, _buildHelpSection(
                      context,
                      icon: Icons.report_problem_outlined,
                      title: isAr ? 'كيفية تقديم بلاغ صحيح؟' : 'How to submit a correct report?',
                      content: isAr
                          ? 'لتقديم بلاغ فعال، اتبع الخطوات التالية:\n'
                            '1. اضغط على زر الإضافة (+) في القائمة السفلية.\n'
                            '2. اختر بدقة نوع الجريمة من القائمة المتاحة.\n'
                            '3. اكتب وصفاً مفصلاً للحادثة (ماذا، متى، وكيف).\n'
                            '4. التقط صوراً واضحة أو أرفق ملفات تدعم بلاغك.\n'
                            '5. انتظر حتى يتم تحديد موقعك بدقة (يظهر لون أخضر للدقة العالية).\n'
                            '6. اضغط على "إرسال" وسيتلقى المسؤولون بلاغك فوراً.'
                          : 'To submit an effective report, follow these steps:\n'
                            '1. Tap the plus (+) button in the bottom navigation.\n'
                            '2. Precisely select the crime type from the available list.\n'
                            '3. Write a detailed description of the incident (what, when, how).\n'
                            '4. Take clear photos or attach files that support your report.\n'
                            '5. Wait for your location to be accurately determined (green color for high accuracy).\n'
                            '6. Tap "Submit" and officials will receive your report immediately.',
                    )),
                    
                    _buildAnimatedSection(5, _buildHelpSection(
                      context,
                      icon: Icons.gps_fixed,
                      title: isAr ? 'لماذا دقة الموقع مهمة؟' : 'Why is location accuracy important?',
                      content: isAr
                          ? 'دقة الموقع (GPS) تسمح لوحدات التدخل بالوصول إلى مكان الحادث بأسرع وقت possible. إذا كانت الدقة ضعيفة (باللون الأحمر)، حاول الانتقال إلى مكان مكشوف أو تفعيل الواي فاي لتحسين تحديد الموقع.'
                          : 'GPS accuracy allows intervention units to reach the scene as quickly as possible. If accuracy is poor (red color), try moving to an open area or enabling Wi-Fi to improve positioning.',
                    )),
                    
                    _buildAnimatedSection(6, _buildHelpSection(
                      context,
                      icon: Icons.track_changes,
                      title: isAr ? 'ماذا تعني حالات البلاغ؟' : 'What do report statuses mean?',
                      content: isAr
                          ? '• قيد الانتظار: تم استلام بلاغك وهو بانتظار المراجعة.\n'
                            '• قيد المعالجة: المسؤولون يدرسون بلاغك أو أن التدخل جارٍ.\n'
                            '• تم الحل: تم الانتهاء من التعامل مع البلاغ وإغلاقه.'
                          : '• Pending: Your report has been received and is awaiting review.\n'
                            '• In Progress: Officials are studying your report or intervention is underway.\n'
                            '• Resolved: Handling of the report has been completed and closed.',
                    )),
                    
                    _buildAnimatedSection(7, _buildHelpSection(
                      context,
                      icon: Icons.security,
                      title: isAr ? 'هل هويتي محمية؟' : 'Is my identity protected?',
                      content: isAr
                          ? 'نعم، نحن نولي أهمية قصوى لخصوصيتك. يتم تشفير جميع البيانات الشخصية والبلاغات ولا يتم مشاركتها إلا مع السلطات المختصة لغرض المعالجة الأمنية فقط.'
                          : 'Yes, we prioritize your privacy. All personal data and reports are encrypted and only shared with competent authorities for security processing purposes.',
                    )),

                    const SizedBox(height: 32),
                    _buildAnimatedSection(8, _buildSectionTitle(context, isAr ? 'نصائح السلامة' : 'Safety Tips')),
                    _buildAnimatedSection(9, _buildSafetyCard(context, isAr)),
                    
                    const SizedBox(height: 32),
                    _buildAnimatedSection(9, _buildEmergencyCard(context)),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSection(int index, Widget child) {
    return FadeTransition(
      opacity: _animations[index],
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(_animations[index]),
        child: child,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isAr = context.isArabic;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(context.isDarkMode ? 0.3 : 0.05), 
            blurRadius: 20, 
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: context.colors.divider),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.brand.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.help_center_rounded, size: 50, color: context.colors.brand),
          ),
          const SizedBox(height: 20),
          Text(
            isAr ? 'كيف يمكننا مساعدتك؟' : 'How can we help you?',
            style: context.titleLarge?.bold.copyWith(fontSize: 22, color: context.colors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            isAr 
                ? 'دليلك الشامل لاستخدام تطبيق بلاغ أمان والمساهمة في أمن مجتمعك.' 
                : 'Your comprehensive guide to using the Balagh Amen app and contributing to your community\'s security.',
            style: context.bodyMedium?.colored(context.colors.textSecondary).copyWith(height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4, right: 4),
      child: Text(
        title,
        style: context.titleMedium?.bold.colored(context.colors.brand).copyWith(fontSize: 18),
      ),
    );
  }

  Widget _buildStepGuide(BuildContext context, bool isAr) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.divider),
      ),
      child: Column(
        children: [
          _buildStepItem(context, '1', isAr ? 'سجل دخولك' : 'Login', isAr ? 'استخدم رقم هاتفك للوصول إلى حسابك.' : 'Use your phone number to access your account.'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(indent: 40, color: context.colors.divider),
          ),
          _buildStepItem(context, '2', isAr ? 'أنشئ بلاغاً' : 'Create Alert', isAr ? 'اضغط على زر (+) واملأ تفاصيل الحادثة.' : 'Tap the (+) button and fill in incident details.'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(indent: 40, color: context.colors.divider),
          ),
          _buildStepItem(context, '3', isAr ? 'تابع الحالة' : 'Track Status', isAr ? 'راقب تقدم معالجة بلاغك من الإدارة.' : 'Monitor the progress of your report by admin.'),
        ],
      ),
    );
  }

  Widget _buildStepItem(BuildContext context, String step, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: context.colors.brand,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(step, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.bodyLarge?.bold.copyWith(color: context.colors.textPrimary)),
              const SizedBox(height: 4),
              Text(desc, style: context.bodyMedium?.colored(context.colors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHelpSection(BuildContext context, {required IconData icon, required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: context.colors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(context.isDarkMode ? 0.3 : 0.02), 
            blurRadius: 10, 
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.colors.brand.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: context.colors.brand, size: 22),
        ),
        title: Text(
          title, 
          style: context.bodyLarge?.bold.copyWith(
            fontSize: 15,
            color: context.colors.textPrimary,
          ),
        ),
        iconColor: context.colors.brand,
        collapsedIconColor: context.colors.textSecondary,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              content,
              style: context.bodyMedium?.copyWith(
                height: 1.6,
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyCard(BuildContext context, bool isAr) {
    final isDark = context.isDarkMode;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(isDark ? 0.15 : 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                child: const Icon(Icons.lightbulb, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                isAr ? 'نصائح للأمان الشخصي' : 'Personal Safety Tips',
                style: context.titleMedium?.bold.copyWith(
                  color: isDark ? Colors.blue[200] : Colors.blue[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            isAr
                ? '• لا تعرض نفسك للخطر من أجل التقاط صور.\n'
                  '• ابتعد عن مكان الحادث إذا شعرت بتهديد لسلامتك.\n'
                  '• في حالة الجرائم المستمرة، اتصل فوراً بأرقام الطوارئ.\n'
                  '• حافظ على هدوئك وقدم معلومات دقيقة قدر الإمكان.'
                : '• Do not put yourself in danger to take photos.\n'
                  '• Move away from the scene if you feel your safety is threatened.\n'
                  '• In case of ongoing crimes, call emergency numbers immediately.\n'
                  '• Stay calm and provide as accurate information as possible.',
            style: TextStyle(
              fontSize: 14, 
              color: isDark ? Colors.blue[100] : Colors.blue[900], 
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red[800]!, Colors.red[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.emergency_share_rounded, color: Colors.white, size: 45),
          const SizedBox(height: 16),
          Text(
            context.l10n.emergency,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            context.isArabic ? 'في الحالات الطارئة جداً، اتصل مباشرة بالرقم:' : 'In extreme emergencies, call directly:',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.phone_in_talk, color: Colors.red, size: 28),
                const SizedBox(width: 12),
                const Text(
                  '17 / 1548',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
