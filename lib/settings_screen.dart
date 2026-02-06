import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'context_extensions.dart';
import 'models.dart';
import 'theme_provider.dart';
import 'language_provider.dart';
import 'about_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'change_password_screen.dart';
import 'help_screen.dart';

class SettingsScreen extends StatelessWidget {
  final User user;

  const SettingsScreen({super.key, required this.user});

  Future<void> _showLogoutDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.logout),
        content: Text(context.isArabic ? 'هل أنت متأكد من تسجيل الخروج؟' : 'Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(context.l10n.logout),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      context.showSuccess(context.l10n.successLogout);
      await Future.delayed(const Duration(milliseconds: 500));
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // En-tête utilisateur
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: context.colors.brand,
                    child: Text(
                      user.prenom.isNotEmpty ? user.prenom[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.fullName, style: context.titleMedium?.bold),
                        const SizedBox(height: 4),
                        Text(user.phone, style: context.bodySmall?.colored(context.colors.textSecondary)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: user.isAdmin ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user.isAdmin ? context.l10n.admin : context.l10n.user,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: user.isAdmin ? Colors.red : Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Paramètres de l'application
          _buildSectionTitle(context, context.l10n.appSettings),
          const SizedBox(height: 8),

          // Thème
          _buildThemeSetting(context),
          const SizedBox(height: 8),

          // Langue
          _buildLanguageSetting(context),
          const SizedBox(height: 24),

          // Compte
          _buildSectionTitle(context, context.l10n.accountSettings),
          const SizedBox(height: 8),

          _buildSettingItem(
            context,
            icon: Icons.person_outline,
            title: context.l10n.viewProfile,
            subtitle: context.isArabic ? 'عرض معلومات حسابك' : 'View your account information',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ProfileScreen(user: user)),
              );
            },
          ),
          const SizedBox(height: 8),

          _buildSettingItem(
            context,
            icon: Icons.lock_outline,
            title: context.l10n.changePassword,
            subtitle: context.isArabic ? 'تغيير كلمة المرور الخاصة بك' : 'Change your password',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ChangePasswordScreen(user: user)),
              );
            },
          ),
          const SizedBox(height: 24),

          // À propos
          _buildSectionTitle(context, context.isArabic ? 'معلومات' : 'Information'),
          const SizedBox(height: 8),

          _buildSettingItem(
            context,
            icon: Icons.info_outline,
            title: context.l10n.about,
            subtitle: context.isArabic ? 'حول التطبيق والمطورين' : 'About the app and developers',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
          const SizedBox(height: 8),

          _buildSettingItem(
            context,
            icon: Icons.help_outline,
            title: context.l10n.help,
            subtitle: context.isArabic ? 'مركز المساعدة' : 'Help center',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HelpScreen()),
              );
            },
          ),
          const SizedBox(height: 24),

          // Déconnexion
          Card(
            elevation: 2,
            color: Colors.red.withOpacity(0.1),
            child: InkWell(
              onTap: () => _showLogoutDialog(context),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.logout,
                            style: context.bodyLarge?.bold.colored(Colors.red),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.isArabic ? 'تسجيل الخروج من حسابك' : 'Sign out of your account',
                            style: context.bodySmall?.colored(Colors.red.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.red),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Version
          Center(
            child: Column(
              children: [
                Text(
                  '${context.l10n.appTitle} v1.0.0',
                  style: context.bodySmall?.colored(context.colors.textDisabled),
                ),
                const SizedBox(height: 4),
                Text(
                  '© 2024 ${context.l10n.institution}',
                  style: context.bodySmall?.colored(context.colors.textDisabled),
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

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 4, left: 4),
      child: Text(
        title,
        style: context.titleSmall?.bold.colored(context.colors.textSecondary),
      ),
    );
  }

  Widget _buildThemeSetting(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.brightness_6, color: context.colors.brand),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.theme, style: context.bodyLarge?.bold),
                      const SizedBox(height: 4),
                      Text(
                        context.isArabic ? 'اختر المظهر المفضل' : 'Choose your preferred theme',
                        style: context.bodySmall?.colored(context.colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildThemeOption(
                    context,
                    icon: Icons.light_mode,
                    label: context.l10n.themeLight,
                    isSelected: themeProvider.isLightMode,
                    onTap: () => themeProvider.setThemeMode(ThemeMode.light),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildThemeOption(
                    context,
                    icon: Icons.dark_mode,
                    label: context.l10n.themeDark,
                    isSelected: themeProvider.isDarkMode,
                    onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildThemeOption(
                    context,
                    icon: Icons.brightness_auto,
                    label: context.l10n.themeSystem,
                    isSelected: themeProvider.isSystemMode,
                    onTap: () => themeProvider.setThemeMode(ThemeMode.system),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
      BuildContext context, {
        required IconData icon,
        required String label,
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? context.colors.brand.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? context.colors.brand : context.colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? context.colors.brand : context.colors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? context.colors.brand : context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSetting(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.language, color: context.colors.brand),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.language, style: context.bodyLarge?.bold),
                      const SizedBox(height: 4),
                      Text(
                        context.isArabic ? 'اختر لغة التطبيق' : 'Choose app language',
                        style: context.bodySmall?.colored(context.colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildLanguageOption(
                    context,
                    label: 'العربية',
                    flag: '🇩🇿',
                    isSelected: languageProvider.isArabic,
                    onTap: () => languageProvider.setArabic(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLanguageOption(
                    context,
                    label: 'English',
                    flag: '🇬🇧',
                    isSelected: languageProvider.isEnglish,
                    onTap: () => languageProvider.setEnglish(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, {
        required String label,
        required String flag,
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? context.colors.brand.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? context.colors.brand : context.colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(flag, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? context.colors.brand : context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: context.colors.brand),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.bodyLarge?.bold),
                    const SizedBox(height: 4),
                    Text(subtitle, style: context.bodySmall?.colored(context.colors.textSecondary)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: context.colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
