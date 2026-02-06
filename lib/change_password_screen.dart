import 'package:flutter/material.dart';
import 'context_extensions.dart';
import 'database_helper.dart';
import 'models.dart';
import 'utils.dart';

class ChangePasswordScreen extends StatefulWidget {
  final User user;

  const ChangePasswordScreen({super.key, required this.user});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureOld = true;
  bool _obscureNew = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final oldHash = Utils.hashPassword(_oldPasswordController.text);
      if (oldHash != widget.user.passwordHash) {
        context.showError(context.isArabic ? 'كلمة المرور الحالية غير صحيحة' : 'Current password is incorrect');
        return;
      }

      final newHash = Utils.hashPassword(_newPasswordController.text);
      await DatabaseHelper.instance.updateUserPassword(widget.user.id!, newHash);

      if (mounted) {
        context.showSuccess(context.isArabic ? 'تم تغيير كلمة المرور بنجاح' : 'Password changed successfully');
        Navigator.pop(context);
      }
    } catch (e) {
      context.showError('${context.l10n.error}: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.changePassword),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPasswordField(
                controller: _oldPasswordController,
                label: context.isArabic ? 'كلمة المرور الحالية' : 'Current Password',
                obscure: _obscureOld,
                onToggle: () => setState(() => _obscureOld = !_obscureOld),
                validator: (v) => (v == null || v.isEmpty) ? context.l10n.fieldRequired : null,
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                controller: _newPasswordController,
                label: context.isArabic ? 'كلمة المرور الجديدة' : 'New Password',
                obscure: _obscureNew,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
                validator: (v) => !Utils.isValidPassword(v ?? '') ? context.l10n.errorInvalidPassword : null,
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                controller: _confirmPasswordController,
                label: context.l10n.confirmPassword,
                obscure: true,
                onToggle: null,
                validator: (v) => v != _newPasswordController.text ? context.l10n.errorPasswordMismatch : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updatePassword,
                  style: ElevatedButton.styleFrom(backgroundColor: context.colors.brand, foregroundColor: Colors.white),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(context.l10n.save, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback? onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: onToggle != null ? IconButton(icon: Icon(obscure ? Icons.visibility_off : Icons.visibility), onPressed: onToggle) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }
}
