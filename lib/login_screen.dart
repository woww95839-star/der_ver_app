import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'context_extensions.dart';
import 'database_helper.dart';
import 'models.dart';
import 'utils.dart';
import 'admin_home_screen.dart';
import 'user_home_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'language_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController(); 
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final identifier = _identifierController.text.trim();
      final password = _passwordController.text.trim();

      User? user;
      user = await DatabaseHelper.instance.getUserByPhone(identifier);

      if (user == null) {
        final allUsers = await DatabaseHelper.instance.getAllUsers();
        final db = await DatabaseHelper.instance.database;
        final adminMaps = await db.query('users', where: 'role = ?', whereArgs: ['admin']);
        final admins = adminMaps.map((m) => User.fromMap(m)).toList();
        final allPossibleUsers = [...allUsers, ...admins];

        for (var u in allPossibleUsers) {
          final fullName1 = '${u.prenom} ${u.nom}'.toLowerCase();
          final fullName2 = '${u.nom} ${u.prenom}'.toLowerCase();
          final searchTerm = identifier.toLowerCase();

          if (fullName1 == searchTerm || fullName2 == searchTerm || u.prenom.toLowerCase() == searchTerm || u.nom.toLowerCase() == searchTerm) {
            user = u;
            break;
          }
        }
      }

      if (user == null) {
        if (!mounted) return;
        context.showError(context.l10n.errorUserNotFound);
        setState(() => _isLoading = false);
        return;
      }

      // ✅ VÉRIFIER SI L'UTILISATEUR EST BLOQUÉ
      if (user.isBlocked) {
        if (!mounted) return;
        context.showError(context.l10n.errorBlockedAccount);
        setState(() => _isLoading = false);
        return;
      }

      final passwordHash = Utils.hashPassword(password);
      if (user.passwordHash != passwordHash) {
        if (!mounted) return;
        context.showError(context.l10n.errorWrongPassword);
        setState(() => _isLoading = false);
        return;
      }

      if (!mounted) return;
      context.showSuccess('${context.l10n.successLogin}: ${user.fullName}');
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      if (user.role == 'admin') {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AdminHomeScreen(admin: user!)));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UserHomeScreen(user: user!)));
      }
    } catch (e) {
      if (!mounted) return;
      context.showError('${context.l10n.errorLoginFailed}: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(context.spacingLG),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ✅ LOGO DESIGNED (RECRÉÉ À PARTIR DE L'IMAGE)
                      Center(
                        child: Container(
                          width: 140,
                          height: 140,
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
                          padding: const EdgeInsets.all(8), // Bordure blanche extérieure
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF5D1E1E), // Rouge foncé / Marron
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.shield,
                                  size: 60,
                                  color: Colors.white, // Effet argent/blanc
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "ALERTS",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    fontFamily: 'monospace', // Pour un look plus technique
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: context.spacingLG),
                      Text(context.l10n.appTitle, style: context.displaySmall?.bold.colored(context.colors.brand), textAlign: TextAlign.center),
                      SizedBox(height: context.spacingSM),
                      Text(context.l10n.appDescription, style: context.bodyLarge?.colored(context.colors.textSecondary), textAlign: TextAlign.center),
                      SizedBox(height: context.spacingXXL),
                      TextFormField(
                        controller: _identifierController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: context.isArabic ? 'رقم الهاتف أو الاسم الكامل' : 'Phone or Full Name',
                          hintText: context.isArabic ? 'مثال: 0550000000 أو محمد أحمد' : 'Ex: 0550000000 or Mohamed Ahmed',
                          prefixIcon: Icon(Icons.person, color: context.colors.textSecondary),
                          filled: true,
                          fillColor: context.colors.surface,
                          border: OutlineInputBorder(borderRadius: context.radiusMD),
                        ),
                        validator: (value) => (value == null || value.isEmpty) ? context.l10n.fieldRequired : null,
                      ),
                      SizedBox(height: context.spacingMD),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: context.l10n.password,
                          hintText: '••••••',
                          prefixIcon: Icon(Icons.lock, color: context.colors.textSecondary),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: context.colors.textSecondary),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          filled: true,
                          fillColor: context.colors.surface,
                          border: OutlineInputBorder(borderRadius: context.radiusMD),
                        ),
                        validator: (value) => (value == null || value.isEmpty) ? context.l10n.fieldRequired : (value.length < 6 ? context.l10n.errorInvalidPassword : null),
                      ),
                      SizedBox(height: context.spacingLG),
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(backgroundColor: context.colors.brand, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: context.radiusMD)),
                          child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(context.l10n.login, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(height: context.spacingMD),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                        child: Text(context.l10n.forgotPassword, style: TextStyle(color: context.colors.brand, fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(height: context.spacingXL),
                      Row(
                        children: [
                          Expanded(child: Divider(color: context.colors.divider)),
                          Padding(padding: EdgeInsets.symmetric(horizontal: context.spacingMD), child: Text(context.l10n.or, style: context.bodySmall?.colored(context.colors.textSecondary))),
                          Expanded(child: Divider(color: context.colors.divider)),
                        ],
                      ),
                      SizedBox(height: context.spacingXL),
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen())),
                        style: OutlinedButton.styleFrom(foregroundColor: context.colors.brand, side: BorderSide(color: context.colors.brand, width: 2), shape: RoundedRectangleBorder(borderRadius: context.radiusMD), padding: const EdgeInsets.symmetric(vertical: 16)),
                        child: Text(context.l10n.register, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: context.spacingXL),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: context.colors.info.withOpacity(0.1), borderRadius: context.radiusSM, border: Border.all(color: context.colors.info.withOpacity(0.3))),
                        child: Column(
                          children: [
                            Icon(Icons.info_outline, color: context.colors.info, size: 20),
                            const SizedBox(height: 8),
                            Text(context.isArabic ? 'للمسؤولين: استخدم admin / admin123' : 'For admins: use admin / admin123', style: TextStyle(fontSize: 12, color: context.colors.info), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ✅ BOUTON SWITCH LANGUE
            Positioned(
              top: 10,
              right: context.isArabic ? null : 10,
              left: context.isArabic ? 10 : null,
              child: ActionChip(
                avatar: Text(context.isArabic ? '🇬🇧' : '🇩🇿', style: const TextStyle(fontSize: 16)),
                label: Text(context.isArabic ? 'English' : 'العربية', style: TextStyle(color: context.colors.brand, fontWeight: FontWeight.bold)),
                onPressed: () {
                  if (context.isArabic) {
                    languageProvider.setEnglish();
                  } else {
                    languageProvider.setArabic();
                  }
                },
                backgroundColor: context.colors.surface,
                side: BorderSide(color: context.colors.brand.withOpacity(0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
