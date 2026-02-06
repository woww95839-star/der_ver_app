import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'utils.dart';
import 'context_extensions.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _phoneController = TextEditingController();
  final _answer1Controller = TextEditingController();
  final _answer2Controller = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  int _currentStep = 0;
  bool _isLoading = false;
  int? _userId;
  List<String> _questions = [];
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _answer1Controller.dispose();
    _answer2Controller.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _verifyPhone() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      context.showError(context.isArabic ? 'الرجاء إدخال رقم الهاتف' : 'Please enter phone number');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await DatabaseHelper.instance.getUserByPhone(phone);
      
      if (user == null) {
        context.showError(context.l10n.errorUserNotFound);
        setState(() => _isLoading = false);
        return;
      }

      final securityQuestions = await DatabaseHelper.instance.getSecurityQuestionsByUserId(user.id!);

      if (securityQuestions.isEmpty) {
        context.showError(context.isArabic ? 'لا توجد أسئلة سرية لهذا الحساب' : 'No security questions for this account');
        setState(() => _isLoading = false);
        return;
      }

      setState(() {
        _userId = user.id;
        _questions = securityQuestions.map((q) => q.question).toList();
        _currentStep = 1;
        _isLoading = false;
      });
    } catch (e) {
      context.showError('${context.l10n.error}: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyAnswers() async {
    final answer1 = _answer1Controller.text.trim();
    final answer2 = _answer2Controller.text.trim();

    if (answer1.isEmpty || answer2.isEmpty) {
      context.showError(context.isArabic ? 'الرجاء الإجابة على السؤالين' : 'Please answer both questions');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final securityQuestions = await DatabaseHelper.instance.getSecurityQuestionsByUserId(_userId!);

      bool answer1Valid = false;
      bool answer2Valid = false;

      for (var sq in securityQuestions) {
        if (sq.question == _questions[0]) {
          answer1Valid = Utils.verifyPassword(answer1.toLowerCase(), sq.answerHash);
        }
        if (sq.question == _questions[1]) {
          answer2Valid = Utils.verifyPassword(answer2.toLowerCase(), sq.answerHash);
        }
      }

      if (!answer1Valid || !answer2Valid) {
        context.showError(context.isArabic ? 'الإجابات غير صحيحة' : 'Incorrect answers');
        setState(() => _isLoading = false);
        return;
      }

      setState(() {
        _currentStep = 2;
        _isLoading = false;
      });
    } catch (e) {
      context.showError('${context.l10n.error}: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      context.showError(context.l10n.fieldRequired);
      return;
    }

    if (!Utils.isValidPassword(newPassword)) {
      context.showError(context.l10n.errorInvalidPassword);
      return;
    }

    if (newPassword != confirmPassword) {
      context.showError(context.l10n.errorPasswordMismatch);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final newPasswordHash = Utils.hashPassword(newPassword);
      await DatabaseHelper.instance.updateUserPassword(_userId!, newPasswordHash);

      if (!mounted) return;

      context.showSuccess(context.isArabic ? 'تم تغيير كلمة المرور بنجاح!' : 'Password changed successfully!');
      Navigator.pop(context);
    } catch (e) {
      context.showError('${context.l10n.error}: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.forgotPassword)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _buildStepIndicator(0, context.l10n.phoneNumber),
                  _buildStepConnector(0),
                  _buildStepIndicator(1, context.isArabic ? 'الأسئلة' : 'Questions'),
                  _buildStepConnector(1),
                  _buildStepIndicator(2, context.l10n.password),
                ],
              ),
              const SizedBox(height: 32),

              if (_currentStep == 0) _buildPhoneStep(),
              if (_currentStep == 1) _buildQuestionsStep(),
              if (_currentStep == 2) _buildPasswordStep(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep == step;
    final isCompleted = _currentStep > step;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? Colors.green : isActive ? context.colors.brand : Colors.grey[300],
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Text('${step + 1}', style: TextStyle(color: isActive ? Colors.white : Colors.grey[600], fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: isActive ? context.colors.brand : Colors.grey[600]), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildStepConnector(int step) {
    final isCompleted = _currentStep > step;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 30),
        color: isCompleted ? Colors.green : Colors.grey[300],
      ),
    );
  }

  Widget _buildPhoneStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.isArabic ? 'أدخل رقم هاتفك' : 'Enter your phone number',
          style: context.titleLarge, 
          textAlign: TextAlign.center
        ),
        const SizedBox(height: 24),
        
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: context.l10n.phoneNumber,
            prefixIcon: const Icon(Icons.phone),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 24),
        
        ElevatedButton(
          onPressed: _isLoading ? null : _verifyPhone,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.brand,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(context.l10n.next),
        ),
      ],
    );
  }

  Widget _buildQuestionsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.isArabic ? 'أجب على الأسئلة السرية' : 'Answer security questions',
          style: context.titleLarge, 
          textAlign: TextAlign.center
        ),
        const SizedBox(height: 24),
        
        if (_questions.isNotEmpty) ...[
          Text(_questions[0], style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _answer1Controller,
            decoration: InputDecoration(
              labelText: '${context.l10n.answer} 1',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        if (_questions.length > 1) ...[
          Text(_questions[1], style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _answer2Controller,
            decoration: InputDecoration(
              labelText: '${context.l10n.answer} 2',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 24),
        ],
        
        ElevatedButton(
          onPressed: _isLoading ? null : _verifyAnswers,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.brand,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(context.l10n.confirm),
        ),
      ],
    );
  }

  Widget _buildPasswordStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.isArabic ? 'أدخل كلمة مرور جديدة' : 'Enter new password',
          style: context.titleLarge, 
          textAlign: TextAlign.center
        ),
        const SizedBox(height: 24),
        
        TextFormField(
          controller: _newPasswordController,
          obscureText: _obscureNewPassword,
          decoration: InputDecoration(
            labelText: context.isArabic ? 'كلمة المرور الجديدة' : 'New Password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_obscureNewPassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            helperText: context.l10n.passwordHint,
          ),
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: context.l10n.confirmPassword,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 24),
        
        ElevatedButton(
          onPressed: _isLoading ? null : _resetPassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.brand,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(context.l10n.resetPassword),
        ),
      ],
    );
  }
}
