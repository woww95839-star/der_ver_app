import 'package:flutter/material.dart';
import 'context_extensions.dart';
import 'models.dart';
import 'utils.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.viewProfile),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: context.colors.brand,
              child: Text(
                user.prenom.isNotEmpty ? user.prenom[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.fullName,
              style: context.titleLarge?.bold,
            ),
            Text(
              user.isAdmin ? context.l10n.admin : context.l10n.user,
              style: TextStyle(color: context.colors.brand, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            _buildInfoCard(
              context,
              title: context.l10n.phoneNumber,
              value: user.phone,
              icon: Icons.phone_outlined,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: context.l10n.nationalCard,
              value: user.nationalCardNumber,
              icon: Icons.badge_outlined,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: context.l10n.lastName,
              value: user.nom,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: context.l10n.firstName,
              value: user.prenom,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required String value, required IconData icon}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.colors.border.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.colors.brand.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: context.colors.brand),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.bodySmall?.colored(context.colors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: context.bodyLarge?.bold,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
