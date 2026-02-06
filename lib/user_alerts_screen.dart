import 'dart:io';
import 'package:flutter/material.dart';
import 'models.dart';
import 'database_helper.dart';
import 'utils.dart';
import 'alert_detail_screen.dart';
import 'context_extensions.dart';

class UserAlertsScreen extends StatefulWidget {
  final User user;
  const UserAlertsScreen({super.key, required this.user});

  @override
  State<UserAlertsScreen> createState() => _UserAlertsScreenState();
}

class _UserAlertsScreenState extends State<UserAlertsScreen> {
  List<AlertWithDetails> _alerts = [];
  bool _isLoading = true;
  String? _filterStatus;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    setState(() => _isLoading = true);

    try {
      final alerts = await DatabaseHelper.instance.getAlertsByUserId(widget.user.id!);
      List<AlertWithDetails> alertsWithDetails = [];
      
      for (var alert in alerts) {
        if (_filterStatus != null && alert.status != _filterStatus) {
          continue;
        }
        
        final photos = await DatabaseHelper.instance.getPhotosByAlertId(alert.id!);
        final files = await DatabaseHelper.instance.getFilesByAlertId(alert.id!);
        final messageCount = await DatabaseHelper.instance.getMessageCountByAlertId(alert.id!);
        
        alertsWithDetails.add(AlertWithDetails(
          alert: alert,
          user: widget.user,
          photos: photos,
          files: files,
          messageCount: messageCount,
        ));
      }

      setState(() {
        _alerts = alertsWithDetails;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        context.showError('${context.l10n.error}: $e');
      }
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.filterByStatus),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(context.l10n.all),
              leading: Radio<String?>(
                value: null,
                groupValue: _filterStatus,
                onChanged: (value) {
                  setState(() => _filterStatus = value);
                  Navigator.pop(context);
                  _loadAlerts();
                },
              ),
            ),
            ListTile(
              title: Text(context.l10n.statusPending),
              leading: Radio<String?>(
                value: 'pending',
                groupValue: _filterStatus,
                onChanged: (value) {
                  setState(() => _filterStatus = value);
                  Navigator.pop(context);
                  _loadAlerts();
                },
              ),
            ),
            ListTile(
              title: Text(context.l10n.statusInProgress),
              leading: Radio<String?>(
                value: 'in_progress',
                groupValue: _filterStatus,
                onChanged: (value) {
                  setState(() => _filterStatus = value);
                  Navigator.pop(context);
                  _loadAlerts();
                },
              ),
            ),
            ListTile(
              title: Text(context.l10n.statusResolved),
              leading: Radio<String?>(
                value: 'resolved',
                groupValue: _filterStatus,
                onChanged: (value) {
                  setState(() => _filterStatus = value);
                  Navigator.pop(context);
                  _loadAlerts();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.myAlerts),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: _showFilterDialog),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAlerts),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _alerts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        _filterStatus != null ? context.l10n.noAlertsFiltered : context.l10n.noAlerts,
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadAlerts,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _alerts.length,
                    itemBuilder: (context, index) {
                      final item = _alerts[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AlertDetailScreen(
                                  alertId: item.alert.id!,
                                  currentUser: widget.user,
                                ),
                              ),
                            );
                            _loadAlerts();
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: context.colors.brand.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        Utils.getAlertTypeName(item.alert.type, context.isArabic),
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.colors.brand),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: item.alert.statusColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        item.alert.getStatusLabel(context.l10n),
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: item.alert.statusColor),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                
                                Text(
                                  Utils.truncateText(item.alert.description, 100),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 12),

                                if (item.photos.isNotEmpty)
                                  SizedBox(
                                    height: 60,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: item.photos.length > 3 ? 3 : item.photos.length,
                                      itemBuilder: (context, photoIndex) {
                                        return Container(
                                          margin: const EdgeInsets.only(left: 8),
                                          width: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: context.colors.border),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.file(
                                              File(item.photos[photoIndex].photoPath),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                const SizedBox(height: 12),

                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 16, color: context.colors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(
                                      Utils.getRelativeTime(item.alert.createdAt, context.l10n),
                                      style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
                                    ),
                                    const Spacer(),
                                    if (item.messageCount > 0)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.message, size: 14, color: Colors.blue),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${item.messageCount}',
                                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      context.isArabic ? Icons.chevron_left : Icons.chevron_right,
                                      color: context.colors.textDisabled,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
