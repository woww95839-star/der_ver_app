import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database_helper.dart';
import 'models.dart';
import 'utils.dart';
import 'context_extensions.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalCardController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _answer1Controller = TextEditingController();
  final _answer2Controller = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _selectedQuestion1;
  String? _selectedQuestion2;

  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.red;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.forward();
    _passwordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _phoneController.dispose();
    _nationalCardController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _answer1Controller.dispose();
    _answer2Controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength() {
    final password = _passwordController.text;
    double strength = 0.0;
    String text = '';
    Color color = Colors.red;

    if (password.isEmpty) {
      strength = 0.0;
    } else if (password.length < 6) {
      strength = 0.2;
      text = context.isArabic ? 'ضعيفة جداً' : 'Very weak';
      color = Colors.red;
    } else if (password.length < 8) {
      strength = 0.4;
      text = context.isArabic ? 'ضعيفة' : 'Weak';
      color = Colors.orange;
    } else {
      strength = 0.6;
      text = context.isArabic ? 'متوسطة' : 'Medium';
      color = Colors.yellow[700]!;

      if (RegExp(r'[A-Z]').hasMatch(password) && RegExp(r'[a-z]').hasMatch(password)) strength += 0.1;
      if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.1;
      if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.1;

      if (strength >= 0.8) {
        text = context.isArabic ? 'قوية' : 'Strong';
        color = Colors.lightGreen;
      }
    }

    setState(() {
      _passwordStrength = strength;
      _passwordStrengthText = text;
      _passwordStrengthColor = color;
    });
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedQuestion1 == null || _selectedQuestion2 == null) {
      context.showError(context.isArabic ? 'يرجى اختيار سؤالين للأمان' : 'Please select two security questions');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final nom = _nomController.text.trim();
      final prenom = _prenomController.text.trim();
      final phone = _phoneController.text.trim();
      final nationalCard = _nationalCardController.text.trim();
      final password = _passwordController.text;

      final existingUser = await DatabaseHelper.instance.getUserByPhone(phone);
      if (existingUser != null) {
        context.showError(context.isArabic ? 'رقم الهاتف مسجل مسبقاً' : 'Phone number already registered');
        return;
      }

      final passwordHash = Utils.hashPassword(password);
      final newUser = User(
        phone: phone,
        nom: nom,
        prenom: prenom,
        nationalCardNumber: nationalCard,
        passwordHash: passwordHash,
        role: 'user',
      );

      final userId = await DatabaseHelper.instance.createUser(newUser);

      final question1 = SecurityQuestion(
        userId: userId,
        question: _selectedQuestion1!,
        answerHash: Utils.hashPassword(_answer1Controller.text.trim().toLowerCase()),
      );
      final question2 = SecurityQuestion(
        userId: userId,
        question: _selectedQuestion2!,
        answerHash: Utils.hashPassword(_answer2Controller.text.trim().toLowerCase()),
      );

      await DatabaseHelper.instance.createSecurityQuestion(question1);
      await DatabaseHelper.instance.createSecurityQuestion(question2);

      if (mounted) {
        context.showSuccess(context.l10n.successRegister);
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      context.showError('${context.l10n.errorRegisterFailed}: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final securityQuestions = Utils.getSecurityQuestions(context.l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.registerWelcome),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Icon(Icons.person_add, size: 64, color: context.colors.brand),
                    const SizedBox(height: 16),
                    Text(context.l10n.registerSubtitle, style: context.bodyMedium),
                    const SizedBox(height: 32),

                    _buildTextField(
                      controller: _nomController,
                      label: context.l10n.lastName,
                      hint: '',
                      icon: Icons.person_outline,
                      validator: (v) => (v == null || v.isEmpty) ? context.l10n.fieldRequired : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _prenomController,
                      label: context.l10n.firstName,
                      hint: '',
                      icon: Icons.badge_outlined,
                      validator: (v) => (v == null || v.isEmpty) ? context.l10n.fieldRequired : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      label: context.l10n.phoneNumber,
                      hint: '05xxxxxxxx',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) => !Utils.isValidPhoneNumber(v ?? '') ? context.l10n.errorInvalidPhone : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _nationalCardController,
                      label: context.l10n.nationalCard,
                      hint: '8-18 digits',
                      icon: Icons.credit_card,
                      keyboardType: TextInputType.number,
                      maxLength: 18, // ✅ Augmenté pour les cartes biométriques
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) => !Utils.isValidNationalCard(v ?? '') ? context.l10n.errorInvalidNationalCard : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      label: context.l10n.password,
                      hint: '',
                      icon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (v) => (v == null || v.length < 6) ? context.l10n.errorInvalidPassword : null,
                    ),
                    if (_passwordController.text.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: _passwordStrength, color: _passwordStrengthColor, backgroundColor: Colors.grey[300]),
                      Text(_passwordStrengthText, style: TextStyle(color: _passwordStrengthColor, fontSize: 12)),
                    ],
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _confirmPasswordController,
                      label: context.l10n.confirmPassword,
                      hint: '',
                      icon: Icons.lock_outline,
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                      validator: (v) => (v != _passwordController.text) ? context.l10n.errorPasswordMismatch : null,
                    ),
                    const SizedBox(height: 24),
                    
                    Text(context.l10n.securityQuestions, style: context.titleMedium?.bold),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      value: _selectedQuestion1,
                      items: securityQuestions,
                      label: '${context.l10n.securityQuestions} 1',
                      onChanged: (v) => setState(() => _selectedQuestion1 = v),
                    ),
                    if (_selectedQuestion1 != null)
                      _buildTextField(controller: _answer1Controller, label: context.l10n.answer, hint: '', icon: Icons.edit),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      value: _selectedQuestion2,
                      items: securityQuestions.where((q) => q != _selectedQuestion1).toList(),
                      label: '${context.l10n.securityQuestions} 2',
                      onChanged: (v) => setState(() => _selectedQuestion2 = v),
                    ),
                    if (_selectedQuestion2 != null)
                      _buildTextField(controller: _answer2Controller, label: context.l10n.answer, hint: '', icon: Icons.edit),

                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(backgroundColor: context.colors.brand, foregroundColor: Colors.white),
                        child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(context.l10n.register, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        counterText: "", // Masquer le compteur de caractères par défaut
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown({required String? value, required List<String> items, required String label, required void Function(String?) onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      items: items.map((q) => DropdownMenuItem(value: q, child: Text(q, overflow: TextOverflow.ellipsis))).toList(),
      onChanged: onChanged,
    );
  }
}
