import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'context_extensions.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email copied to clipboard: $email')),
          );
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
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$message: $text')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.aboutApp),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(context),
          const SizedBox(height: 32),

          _buildSection(
            context,
            icon: Icons.info_outline,
            title: context.l10n.aboutTitle,
            child: Text(
              context.l10n.aboutDescription,
              style: context.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),

          _buildSection(
            context,
            icon: Icons.school,
            title: context.l10n.aboutResearchers,
            child: Column(
              children: [
                _buildPersonCard(
                  context,
                  name: context.l10n.researcher1,
                  subtitle: context.l10n.institution,
                  icon: Icons.person,
                  color: Colors.purple,
                ),
                const SizedBox(height: 8),
                _buildPersonCard(
                  context,
                  name: context.l10n.researcher2,
                  subtitle: context.l10n.institution,
                  icon: Icons.person,
                  color: Colors.purple,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _buildSection(
            context,
            icon: Icons.account_balance,
            title: context.l10n.aboutInstitution,
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.account_balance, color: Colors.blue, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        context.l10n.institution,
                        style: context.bodyMedium?.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          _buildSection(
            context,
            icon: Icons.code,
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
                  color: Colors.green,
                ),
                const SizedBox(height: 8),
                _buildDeveloperCard(
                  context,
                  name: context.l10n.developer2,
                  email: context.l10n.developer2Email,
                  phone: context.l10n.developer2Phone,
                  address: context.l10n.developer2Address,
                  locationUrl: context.l10n.developer2Location,
                  color: Colors.green,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _buildSection(
            context,
            icon: Icons.star_outline,
            title: context.l10n.appFeatures,
            child: Column(
              children: [
                _buildFeatureItem(context, Icons.location_on, context.l10n.feature1),
                _buildFeatureItem(context, Icons.photo_camera, context.l10n.feature2),
                _buildFeatureItem(context, Icons.chat, context.l10n.feature3),
                _buildFeatureItem(context, Icons.track_changes, context.l10n.feature4),
                _buildFeatureItem(context, Icons.language, context.l10n.feature5),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _buildSection(
            context,
            icon: Icons.info,
            title: context.l10n.aboutVersion,
            child: Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.l10n.appVersion, style: context.bodyMedium),
                        Text('1.1', style: context.bodyMedium?.bold),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.l10n.buildNumber, style: context.bodyMedium),
                        Text('1.1', style: context.bodyMedium?.bold),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          Center(
            child: Column(
              children: [
                Text(
                  '© 2026 ${context.l10n.appTitle}',
                  style: context.bodySmall?.colored(context.colors.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.institution,
                  style: context.bodySmall?.colored(context.colors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // ✅ LOGO DESIGNED (RECRÉÉ À PARTIR DE L\u0027IMAGE DANS ABOUT AUSSI)
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(6),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF5D1E1E),
              shape: BoxShape.circle,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shield,
                  size: 50,
                  color: Colors.white,
                ),
                SizedBox(height: 2),
                Text(
                  "ALERTS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.appTitle,
          style: context.headlineMedium?.bold.colored(context.colors.brand),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.appDescription,
          style: context.bodyMedium?.colored(context.colors.textSecondary),
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
            const SizedBox(width: 8),
            Text(
              title,
              style: context.titleMedium?.bold,
            ),
          ],
        ),
        const SizedBox(height: 12),
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
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: context.bodyLarge?.bold),
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
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.code, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: context.bodyLarge?.bold),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => _launchMaps(locationUrl),
                        onLongPress: () => _copyToClipboard(context, address, 'Address copied'),
                        child: Text(
                          address,
                          style: context.bodySmall?.colored(Colors.blue).copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildContactButton(
                  context,
                  icon: Icons.phone,
                  label: context.l10n.call,
                  onTap: () => _launchPhone(phone),
                  color: Colors.green,
                ),
                _buildContactButton(
                  context,
                  icon: Icons.email,
                  label: context.l10n.email,
                  onTap: () => _launchEmail(context, email),
                  onLongPress: () => _copyToClipboard(context, email, 'Email copied'),
                  color: Colors.blue,
                ),
                _buildContactButton(
                  context,
                  icon: Icons.location_on,
                  label: context.l10n.alertLocation,
                  onTap: () => _launchMaps(locationUrl),
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: context.bodySmall?.colored(color).copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: context.colors.brand),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: context.bodyMedium),
          ),
        ],
      ),
    );
  }
}
