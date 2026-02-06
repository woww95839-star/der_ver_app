import 'package:flutter/material.dart';
import 'context_extensions.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = context.isArabic;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.help),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHelpSection(
            context,
            icon: Icons.report_problem_outlined,
            title: isAr ? 'كيفية تقديم بلاغ' : 'How to report a crime',
            content: isAr
                ? 'اضغط على زر "+" في الصفحة الرئيسية، اختر نوع الجريمة، أضف وصفاً، التقط صوراً إذا أمكن، ثم أكد موقعك الجغرافي وأرسل البلاغ.'
                : 'Tap the "+" button on the home screen, select the crime type, add a description, take photos if possible, confirm your location, and submit.',
          ),
          _buildHelpSection(
            context,
            icon: Icons.track_changes,
            title: isAr ? 'متابعة البلاغات' : 'Track your reports',
            content: isAr
                ? 'يمكنك متابعة حالة بلاغاتك (قيد الانتظار، قيد المعالجة، تم الحل) من خلال تبويب "بلاغاتي" في القائمة السفلية.'
                : 'You can track the status of your reports (Pending, In Progress, Resolved) through the "My Alerts" tab in the bottom navigation.',
          ),
          _buildHelpSection(
            context,
            icon: Icons.chat_outlined,
            title: isAr ? 'التواصل مع الإدارة' : 'Contact Administration',
            content: isAr
                ? 'يمكنك إرسال ملاحظات أو استفسارات من خلال قسم "الآراء والملاحظات" في الإعدادات.'
                : 'You can send feedback or inquiries through the "Feedback" section in the settings.',
          ),
          _buildHelpSection(
            context,
            icon: Icons.security,
            title: isAr ? 'خصوصية البيانات' : 'Data Privacy',
            content: isAr
                ? 'بياناتك الشخصية وموقعك الجغرافي مشفرة ومحمية، وتستخدم فقط لأغراض الأمن والتدخل السريع.'
                : 'Your personal data and location are encrypted and protected, used only for security purposes and rapid intervention.',
          ),
          const SizedBox(height: 24),
          _buildEmergencyCard(context),
        ],
      ),
    );
  }

  Widget _buildHelpSection(BuildContext context, {required IconData icon, required String title, required String content}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: ExpansionTile(
        leading: Icon(icon, color: context.colors.brand),
        title: Text(title, style: context.bodyLarge?.bold),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(content, style: context.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.emergency_share, color: Colors.red, size: 40),
          const SizedBox(height: 12),
          Text(
            context.l10n.emergency,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 8),
          Text(
            context.isArabic ? 'في الحالات الطارئة جداً، اتصل مباشرة بالرقم:' : 'In extreme emergencies, call directly:',
            textAlign: TextAlign.center,
          ),
          const Text(
            '17 / 1548',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
