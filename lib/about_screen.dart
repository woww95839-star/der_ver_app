import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'context_extensions.dart';
import 'app_logo.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animations = List.generate(8, (index) {
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

  Future<void> _launchEmail(BuildContext context, String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Balagh DZ - Contact',
      },
    );
    
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      } else {
        await Clipboard.setData(ClipboardData(text: email));
        if (mounted) {
          context.showInfo('Email copied to clipboard: $email');
        }
      }
    } catch (e) {
      debugPrint('Error launching email: $e');
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching phone: $e');
    }
  }

  Future<void> _launchMaps(String url) async {
    final Uri mapsUri = Uri.parse(url);
    try {
      if (await canLaunchUrl(mapsUri)) {
        await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching maps: $e');
    }
  }

  Future<void> _copyToClipboard(BuildContext context, String text, String message) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      context.showInfo('$message: $text');
    }
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
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            iconTheme: IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                context.l10n.aboutApp,
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
                child: Center(
                  child: Opacity(
                    opacity: 0.2,
                    child: Icon(Icons.security, size: 150, color: Colors.white),
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
                  children: [
                    _buildAnimatedSection(0, _buildHeader(context)),
                    const SizedBox(height: 32),
                    
                    _buildAnimatedSection(1, _buildSection(
                      context,
                      icon: Icons.lightbulb,
                      title: isAr ? 'مهمتنا' : 'Our Mission',
                      child: Text(
                        isAr 
                          ? 'تهدف منصة "بلاغ أمان" إلى تعزيز الأمن المجتمعي من خلال تمكين المواطنين من الإبلاغ عن التجاوزات والجرائم بكل سهولة وأمان، مما يساهم في سرعة استجابة السلطات المعنية.'
                          : 'The "Balagh Amen" platform aims to enhance community security by enabling citizens to report violations and crimes easily and safely, contributing to the rapid response of the concerned authorities.',
                        style: context.bodyMedium?.copyWith(
                          height: 1.6, 
                          fontSize: 15,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    )),
                    const SizedBox(height: 24),

                    _buildAnimatedSection(2, _buildSection(
                      context,
                      icon: Icons.school,
                      title: context.l10n.aboutResearchers,
                      child: Column(
                        children: [
                          _buildPersonCard(
                            context,
                            name: context.l10n.researcher1,
                            subtitle: context.l10n.institution,
                            icon: Icons.female,
                            color: Colors.purple,
                          ),
                          const SizedBox(height: 12),
                          _buildPersonCard(
                            context,
                            name: context.l10n.researcher2,
                            subtitle: context.l10n.institution,
                            icon: Icons.female,
                            color: Colors.purple,
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 24),

                    _buildAnimatedSection(3, _buildSection(
                      context,
                      icon: Icons.account_balance,
                      title: context.l10n.aboutInstitution,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(isDark ? 0.15 : 0.05),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.blue.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_city, color: Colors.blue, size: 40),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                context.l10n.institution,
                                style: context.bodyMedium?.bold.copyWith(
                                  color: isDark ? Colors.blue[200] : Colors.blue[900],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                    const SizedBox(height: 24),

                    _buildAnimatedSection(4, _buildSection(
                      context,
                      icon: Icons.terminal,
                      title: context.l10n.aboutDevelopers,
                      child: Column(
                        children: [
                          _buildDeveloperCard(
                            context,
                            name: context.l10n.developer1,
                            email: context.l10n.developer1Email,
                            phone: context.l10n.developer1Phone,
                            address: context.l10n.developer1Address,
                            locationUrl: context.l10n.developer1Location,
                            color: Colors.indigo,
                          ),
                          const SizedBox(height: 12),
                          _buildDeveloperCard(
                            context,
                            name: context.l10n.developer2,
                            email: context.l10n.developer2Email,
                            phone: context.l10n.developer2Phone,
                            address: context.l10n.developer2Address,
                            locationUrl: context.l10n.developer2Location,
                            color: Colors.indigo,
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 24),

                    _buildAnimatedSection(5, _buildSection(
                      context,
                      icon: Icons.auto_awesome,
                      title: context.l10n.appFeatures,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: context.colors.divider),
                        ),
                        child: Column(
                          children: [
                            _buildFeatureItem(context, Icons.gps_fixed, context.l10n.feature1, isAr ? 'تحديد دقيق للموقع عبر الأقمار الصناعية' : 'Precise satellite-based location tracking'),
                            _buildFeatureItem(context, Icons.camera_enhance, context.l10n.feature2, isAr ? 'إمكانية رفع الصور والملفات كأدلة' : 'Upload photos and files as evidence'),
                            _buildFeatureItem(context, Icons.forum, context.l10n.feature3, isAr ? 'دردشة مباشرة مع مسؤولي الأمن' : 'Live chat with security officials'),
                            _buildFeatureItem(context, Icons.history, context.l10n.feature4, isAr ? 'سجل كامل لمتابعة حالة بلاغاتك' : 'Full history to track your reports'),
                            _buildFeatureItem(context, Icons.translate, context.l10n.feature5, isAr ? 'دعم كامل للغتين العربية والإنجليزية' : 'Full Arabic and English support'),
                          ],
                        ),
                      ),
                    )),
                    const SizedBox(height: 24),

                    _buildAnimatedSection(6, _buildSection(
                      context,
                      icon: Icons.verified_user,
                      title: isAr ? 'الأمن والخصوصية' : 'Security & Privacy',
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(isDark ? 0.15 : 0.05),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.green.withOpacity(0.2)),
                        ),
                        child: Text(
                          isAr
                            ? 'نحن نستخدم أحدث تقنيات التشفير لحماية بياناتك الشخصية. لا يتم الكشف عن هويتك إلا للجهات المختصة وفقط عند الضرورة القصوى لمعالجة البلاغ.'
                            : 'We use the latest encryption technologies to protect your personal data. Your identity is only disclosed to the competent authorities and only when strictly necessary to process the report.',
                          style: context.bodyMedium?.copyWith(
                            color: isDark ? Colors.green[200] : Colors.green[900], 
                            height: 1.5,
                          ),
                        ),
                      ),
                    )),
                    const SizedBox(height: 40),

                    _buildAnimatedSection(7, Column(
                      children: [
                        Text(
                          '© 2026 ${context.l10n.appTitle}',
                          style: context.bodySmall?.colored(context.colors.textSecondary).copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Version 1.1.0 (Professional Build)',
                          style: context.bodySmall?.colored(context.colors.textDisabled),
                        ),
                        const SizedBox(height: 48),
                      ],
                    )),
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
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(_animations[index]),
        child: child,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        AppLogo(size: 140, color: context.isDarkMode ? context.colors.brandLight : context.colors.brand),
        const SizedBox(height: 24),
        Text(
          context.l10n.appTitle,
          style: context.headlineMedium?.bold.colored(context.colors.brand).copyWith(letterSpacing: 1.2),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            color: context.colors.brand,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.appDescription,
          style: context.bodyMedium?.colored(context.colors.textSecondary).copyWith(
            fontSize: 16, 
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSection(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Widget child,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 24, color: context.colors.brand),
            const SizedBox(width: 12),
            Text(
              title,
              style: context.titleMedium?.bold.colored(context.colors.brand).copyWith(fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }

  Widget _buildPersonCard(
      BuildContext context, {
        required String name,
        required String subtitle,
        required IconData icon,
        required Color color,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(context.isDarkMode ? 0.3 : 0.05), 
            blurRadius: 10, 
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: context.colors.divider),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(context.isDarkMode ? 0.2 : 0.1),
              radius: 25,
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: context.bodyLarge?.bold.copyWith(color: context.colors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: context.bodySmall?.colored(context.colors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeveloperCard(
      BuildContext context, {
        required String name,
        required String email,
        required String phone,
        required String address,
        required String locationUrl,
        required Color color,
      }) {
    final isDark = context.isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), 
            blurRadius: 10, 
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: context.colors.divider),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(isDark ? 0.2 : 0.1),
                  radius: 25,
                  child: Icon(Icons.code, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: context.bodyLarge?.bold.copyWith(color: context.colors.textPrimary)),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => _launchMaps(locationUrl),
                        child: Text(
                          address,
                          style: context.bodySmall?.colored(isDark ? Colors.blue[300]! : Colors.blue).copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: context.colors.surfaceVariant,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildContactIcon(Icons.phone, () => _launchPhone(phone), Colors.green, context.l10n.call),
                _buildContactIcon(Icons.email, () => _launchEmail(context, email), isDark ? Colors.blue[300]! : Colors.blue, context.l10n.email),
                _buildContactIcon(Icons.map, () => _launchMaps(locationUrl), Colors.red, context.l10n.alertLocation),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactIcon(IconData icon, VoidCallback onTap, Color color, String label) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: context.colors.brand),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.bodyMedium?.bold.copyWith(color: context.colors.textPrimary)),
                const SizedBox(height: 4),
                Text(description, style: context.bodySmall?.copyWith(
                  height: 1.4,
                  color: context.colors.textSecondary,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
