import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'models.dart';
import 'database_helper.dart';
import 'utils.dart';
import 'admin_alert_detail_screen.dart';
import 'context_extensions.dart';

class AdminAlertsScreen extends StatefulWidget {
  const AdminAlertsScreen({super.key});

  @override
  State<AdminAlertsScreen> createState() => _AdminAlertsScreenState();
}

class _AdminAlertsScreenState extends State<AdminAlertsScreen> {
  List<AlertWithDetails> _alerts = [];
  List<AlertWithDetails> _filteredAlerts = [];
  bool _isLoading = true;
  String? _filterStatus;
  String? _filterType;
  String _sortBy = 'date_desc'; // ✅ Tri par défaut : plus récent d'abord
  final _searchController = TextEditingController();

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted && !_isLoading) {
        _loadAlerts(silent: true);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadAlerts({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);

    try {
      final alerts = await DatabaseHelper.instance.getAllAlerts();
      List<AlertWithDetails> alertsWithDetails = [];

      for (var alert in alerts) {
        final user = await DatabaseHelper.instance.getUserById(alert.userId);
        if (user == null) continue;

        final photos = await DatabaseHelper.instance.getPhotosByAlertId(alert.id!);
        final files = await DatabaseHelper.instance.getFilesByAlertId(alert.id!);
        final messageCount = await DatabaseHelper.instance.getMessageCountByAlertId(alert.id!);

        alertsWithDetails.add(AlertWithDetails(
          alert: alert,
          user: user,
          photos: photos,
          files: files,
          messageCount: messageCount,
        ));
      }

      if (mounted) {
        setState(() {
          _alerts = alertsWithDetails;
          _applyFiltersAndSort();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        context.showError('${context.l10n.error}: $e');
      }
    }
  }

  void _applyFiltersAndSort() {
    final searchTerm = _searchController.text.toLowerCase().trim();
    
    _filteredAlerts = _alerts.where((item) {
      bool matchesStatus = _filterStatus == null || item.alert.status == _filterStatus;
      bool matchesType = _filterType == null || item.alert.type == _filterType;
      bool matchesSearch = searchTerm.isEmpty ||
          item.alert.description.toLowerCase().contains(searchTerm) ||
          item.user.fullName.toLowerCase().contains(searchTerm) ||
          item.alert.type.toLowerCase().contains(searchTerm);

      return matchesStatus && matchesType && matchesSearch;
    }).toList();

    // Tri
    switch (_sortBy) {
      case 'date_desc':
        _filteredAlerts.sort((a, b) => b.alert.createdAt.compareTo(a.alert.createdAt));
        break;
      case 'date_asc':
        _filteredAlerts.sort((a, b) => a.alert.createdAt.compareTo(b.alert.createdAt));
        break;
      case 'status':
        _filteredAlerts.sort((a, b) {
          final statusOrder = {'pending': 0, 'in_progress': 1, 'resolved': 2};
          int cmp = (statusOrder[a.alert.status] ?? 3).compareTo(statusOrder[b.alert.status] ?? 3);
          if (cmp == 0) return b.alert.createdAt.compareTo(a.alert.createdAt);
          return cmp;
        });
        break;
      case 'user':
        _filteredAlerts.sort((a, b) => a.user.fullName.compareTo(b.user.fullName));
        break;
    }
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.isArabic ? 'ترتيب حسب' : 'Sort by'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSortOption(context.isArabic ? 'الأحدث أولاً' : 'Newest first', 'date_desc', Icons.arrow_downward),
            _buildSortOption(context.isArabic ? 'الأقدم أولاً' : 'Oldest first', 'date_asc', Icons.arrow_upward),
            _buildSortOption(context.l10n.alertStatus, 'status', Icons.sort),
            _buildSortOption(context.l10n.user, 'user', Icons.person),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, String value, IconData icon) {
    final isSelected = _sortBy == value;
    return ListTile(
      leading: Icon(icon, color: isSelected ? context.colors.brand : null),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? context.colors.brand : null,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check, color: context.colors.brand) : null,
      onTap: () {
        setState(() {
          _sortBy = value;
          _applyFiltersAndSort();
        });
        Navigator.pop(context);
      },
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.filter),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.alertStatus, style: const TextStyle(fontWeight: FontWeight.bold)),
              RadioListTile<String?>(
                title: Text(context.l10n.all),
                value: null,
                groupValue: _filterStatus,
                onChanged: (v) { setState(() => _filterStatus = v); Navigator.pop(context); _applyFiltersAndSort(); },
              ),
              RadioListTile<String?>(
                title: Text(context.l10n.statusPending),
                value: 'pending',
                groupValue: _filterStatus,
                onChanged: (v) { setState(() => _filterStatus = v); Navigator.pop(context); _applyFiltersAndSort(); },
              ),
              RadioListTile<String?>(
                title: Text(context.l10n.statusInProgress),
                value: 'in_progress',
                groupValue: _filterStatus,
                onChanged: (v) { setState(() => _filterStatus = v); Navigator.pop(context); _applyFiltersAndSort(); },
              ),
              RadioListTile<String?>(
                title: Text(context.l10n.statusResolved),
                value: 'resolved',
                groupValue: _filterStatus,
                onChanged: (v) { setState(() => _filterStatus = v); Navigator.pop(context); _applyFiltersAndSort(); },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.alerts),
            if (_filteredAlerts.isNotEmpty)
              Text(
                '${_filteredAlerts.length} ${context.l10n.alerts}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.sort), onPressed: _showSortDialog),
          IconButton(
            icon: Icon(Icons.filter_list, color: _filterStatus != null ? Colors.orange : null),
            onPressed: _showFilterDialog,
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => _loadAlerts()),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: context.l10n.search,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => setState(() => _applyFiltersAndSort()),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredAlerts.isEmpty
                    ? Center(child: Text(context.l10n.noResults))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredAlerts.length,
                        itemBuilder: (context, index) {
                          final item = _filteredAlerts[index];
                          return _AlertCard(
                            alertWithDetails: item,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminAlertDetailScreen(alertId: item.alert.id!),
                                ),
                              );
                              _loadAlerts(silent: true);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final AlertWithDetails alertWithDetails;
  final VoidCallback onTap;

  const _AlertCard({required this.alertWithDetails, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final alert = alertWithDetails.alert;
    final user = alertWithDetails.user;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
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
                      Utils.getAlertTypeName(alert.type, context.isArabic),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.colors.brand),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: alert.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      alert.getStatusLabel(context.l10n),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: alert.statusColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.grey[300],
                    child: Text(user.prenom.isNotEmpty ? user.prenom[0].toUpperCase() : '?', style: const TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(width: 8),
                  Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Text(alert.description, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    Utils.getRelativeTime(alert.createdAt, context.l10n),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  if (alertWithDetails.messageCount > 0)
                    Icon(Icons.message, size: 14, color: context.colors.brand),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
