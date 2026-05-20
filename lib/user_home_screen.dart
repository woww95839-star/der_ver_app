import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';
import 'utils.dart';
import 'user_alerts_screen.dart';
import 'user_map_screen.dart';
import 'create_alert_screen.dart';
import 'user_feedback_screen.dart';
import 'settings_screen.dart';
import 'user_notifications_screen.dart';
import 'context_extensions.dart';
import 'app_logo.dart';

class UserHomeScreen extends StatefulWidget {
  final User user;

  const UserHomeScreen({super.key, required this.user});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _currentIndex = 0;

  int _totalAlerts = 0;
  int _pendingAlerts = 0;
  int _inProgressAlerts = 0;
  int _resolvedAlerts = 0;
  int _unreadNotifications = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
    _loadUnreadNotifications();
  }

  Future<void> _loadUnreadNotifications() async {
    try {
      final count = await DatabaseHelper.instance.getUnreadNotificationsCount(widget.user.id!);
      if (mounted) {
        setState(() {
          _unreadNotifications = count;
        });
      }
    } catch (e) {
      debugPrint('Error loading unread notifications: $e');
    }
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);

    try {
      final alerts = await DatabaseHelper.instance.getAlertsByUserId(widget.user.id!);

      setState(() {
        _totalAlerts = alerts.length;
        _pendingAlerts = alerts.where((a) => a.status == 'pending').length;
        _inProgressAlerts = alerts.where((a) => a.status == 'in_progress').length;
        _resolvedAlerts = alerts.where((a) => a.status == 'resolved').length;
      });
    } catch (e) {
      if (mounted) {
        context.showError('${context.isArabic ? 'خطأ في تحميل الإحصائيات' : 'Error loading statistics'}: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomePage(
        user: widget.user,
        totalAlerts: _totalAlerts,
        pendingAlerts: _pendingAlerts,
        inProgressAlerts: _inProgressAlerts,
        resolvedAlerts: _resolvedAlerts,
        unreadNotifications: _unreadNotifications,
        isLoading: _isLoading,
        onRefresh: () {
          _loadStats();
          _loadUnreadNotifications();
        },
      ),
      UserAlertsScreen(user: widget.user),
      UserMapScreen(user: widget.user),
      UserFeedbackScreen(user: widget.user),
      SettingsScreen(user: widget.user),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        selectedItemColor: context.colors.brand,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: context.l10n.navHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: context.l10n.navAlerts,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: context.l10n.navMap,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.feedback),
            label: context.l10n.navFeedback,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: context.l10n.navSettings,
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateAlertScreen(user: widget.user),
            ),
          );
          if (result == true) {
            _loadStats();
          }
        },
        backgroundColor: context.colors.brand,
        icon: const Icon(Icons.add),
        label: Text(context.l10n.createAlert),
      )
          : null,
    );
  }
}

class _HomePage extends StatelessWidget {
  final User user;
  final int totalAlerts;
  final int pendingAlerts;
  final int inProgressAlerts;
  final int resolvedAlerts;
  final int unreadNotifications;
  final bool isLoading;
  final VoidCallback onRefresh;

  const _HomePage({
    required this.user,
    required this.totalAlerts,
    required this.pendingAlerts,
    required this.inProgressAlerts,
    required this.resolvedAlerts,
    required this.unreadNotifications,
    required this.isLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = context.isArabic;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
        centerTitle: true,
        leading: Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserNotificationsScreen(user: user),
                  ),
                );
                onRefresh();
              },
              tooltip: context.l10n.notifications,
            ),
            if (unreadNotifications > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$unreadNotifications',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: onRefresh,
            tooltip: context.l10n.refresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => onRefresh(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // PROFILE SECTION WITH NEW BRANDING
            Card(
              elevation: 8,
              shadowColor: context.colors.brand.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [context.colors.brand, context.colors.brandDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Dynamic App Logo as part of profile identity
                        const AppLogo(size: 80, showShadow: false),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.welcome,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.fullName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.verified, color: Colors.white, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      isAr ? 'مواطن مسجل' : 'Verified Citizen',
                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // STATS SECTION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.statistics,
                  style: context.titleLarge?.bold.colored(context.colors.textPrimary),
                ),
                TextButton(
                  onPressed: onRefresh,
                  child: Text(isAr ? 'تحديث' : 'Refresh'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else ...[
              // Grid of statistics
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _StatCard(
                    title: context.l10n.totalAlerts,
                    value: totalAlerts,
                    icon: Icons.assignment_rounded,
                    color: context.colors.info,
                  ),
                  _StatCard(
                    title: context.l10n.statusPending,
                    value: pendingAlerts,
                    icon: Icons.hourglass_empty_rounded,
                    color: context.colors.warning,
                  ),
                  _StatCard(
                    title: context.l10n.statusInProgress,
                    value: inProgressAlerts,
                    icon: Icons.engineering_rounded,
                    color: Colors.indigoAccent,
                  ),
                  _StatCard(
                    title: context.l10n.statusResolved,
                    value: resolvedAlerts,
                    icon: Icons.check_circle_rounded,
                    color: context.colors.success,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Text(
                isAr ? 'الإجراءات السريعة' : 'Quick Actions',
                style: context.titleLarge?.bold.colored(context.colors.textPrimary),
              ),

              const SizedBox(height: 16),

              // Action Buttons with refined design
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      title: context.l10n.createAlert,
                      icon: Icons.add_circle_outline_rounded,
                      color: context.colors.brand,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateAlertScreen(user: user),
                          ),
                        );
                        if (result == true) {
                          onRefresh();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionCard(
                      title: context.l10n.myAlerts,
                      icon: Icons.history_rounded,
                      color: context.colors.info,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserAlertsScreen(user: user),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      title: context.l10n.feedback,
                      icon: Icons.rate_review_rounded,
                      color: context.colors.success,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserFeedbackScreen(user: user),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionCard(
                      title: context.l10n.settings,
                      icon: Icons.tune_rounded,
                      color: context.colors.textSecondary,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(user: user),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Safety Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.colors.brand.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: context.colors.brand.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: context.colors.brand.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shield_rounded,
                        color: context.colors.brand,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? 'أمنكم أولويتنا' : 'Your Safety First',
                            style: context.titleSmall?.bold.colored(context.colors.brand),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isAr 
                              ? 'كل بلاغ ترفعه يساهم في جعل حيّك أكثر أماناً. شكراً لتعاونك.' 
                              : 'Every report you submit helps make your neighborhood safer. Thank you.',
                            style: context.bodySmall?.colored(context.colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: context.colors.divider.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 24, color: color),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          Text(
            title,
            style: context.labelMedium?.bold.colored(context.colors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: context.colors.divider),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: context.labelLarge?.bold.colored(context.colors.textPrimary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
