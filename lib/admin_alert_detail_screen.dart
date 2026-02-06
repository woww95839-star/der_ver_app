import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'models.dart';
import 'database_helper.dart';
import 'utils.dart';
import 'context_extensions.dart';

class AdminAlertDetailScreen extends StatefulWidget {
  final int alertId;

  const AdminAlertDetailScreen({super.key, required this.alertId});

  @override
  State<AdminAlertDetailScreen> createState() => _AdminAlertDetailScreenState();
}

class _AdminAlertDetailScreenState extends State<AdminAlertDetailScreen> {
  AlertWithDetails? _alertWithDetails;
  List<Message> _messages = [];
  final _messageController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final alertWithDetails = await DatabaseHelper.instance.getAlertWithDetails(widget.alertId);
      final messages = await DatabaseHelper.instance.getMessagesByAlertId(widget.alertId);

      setState(() {
        _alertWithDetails = alertWithDetails;
        _messages = messages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _changeStatus(String newStatus) async {
    try {
      await DatabaseHelper.instance.updateAlertStatus(widget.alertId, newStatus);
      
      if (!mounted) return;
      context.showSuccess(context.l10n.successStatusChanged);

      await _loadData();
    } catch (e) {
      if (!mounted) return;
      context.showError('Error: $e');
    }
  }

  void _showStatusDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.changeStatus),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(context.l10n.statusPending),
              leading: const Icon(Icons.pending, color: Colors.orange),
              onTap: () {
                Navigator.pop(context);
                _changeStatus('pending');
              },
            ),
            ListTile(
              title: Text(context.l10n.statusInProgress),
              leading: const Icon(Icons.sync, color: Colors.blue),
              onTap: () {
                Navigator.pop(context);
                _changeStatus('in_progress');
              },
            ),
            ListTile(
              title: Text(context.l10n.statusResolved),
              leading: const Icon(Icons.check_circle, color: Colors.green),
              onTap: () {
                Navigator.pop(context);
                _changeStatus('resolved');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    try {
      final message = Message(alertId: widget.alertId, senderRole: 'admin', message: text);
      await DatabaseHelper.instance.createMessage(message);
      _messageController.clear();
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      context.showError('Error: $e');
    }
  }

  Future<void> _openFile(String filePath) async {
    try {
      final result = await OpenFilex.open(filePath);
      if (result.type != ResultType.done) {
        if (mounted) context.showError('Could not open file: ${result.message}');
      }
    } catch (e) {
      if (mounted) context.showError('Error opening file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.alertDetails)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_alertWithDetails == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.alertDetails)),
        body: Center(child: Text(context.l10n.noData)),
      );
    }

    final alert = _alertWithDetails!.alert;
    final user = _alertWithDetails!.user;
    final photos = _alertWithDetails!.photos;
    final files = _alertWithDetails!.files;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.alertDetails),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _showStatusDialog),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: alert.statusColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(alert.statusIcon, color: alert.statusColor),
                            const SizedBox(width: 8),
                            Text(alert.getStatusLabel(context.l10n), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: alert.statusColor)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.user, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.green,
                              child: Text(
                                user.prenom.isNotEmpty ? user.prenom[0].toUpperCase() : '?',
                                style: const TextStyle(fontSize: 20, color: Colors.white)
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.fullName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text(user.phone, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: _InfoCard(title: context.l10n.alertType, value: alert.type, icon: Icons.category)),
                    const SizedBox(width: 12),
                    Expanded(child: _InfoCard(title: context.l10n.alertDate, value: Utils.formatDate(alert.createdAt), icon: Icons.calendar_today)),
                  ],
                ),
                const SizedBox(height: 16),

                Text(context.l10n.alertDescription, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Card(child: Padding(padding: const EdgeInsets.all(16.0), child: Text(alert.description))),
                const SizedBox(height: 16),

                if (photos.isNotEmpty) ...[
                  Text('${context.l10n.alertPhotos} (${photos.length})', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: photos.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(left: 12),
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(File(photos[index].photoPath), fit: BoxFit.cover),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                if (files.isNotEmpty) ...[
                  Text('${context.l10n.alertFiles} (${files.length})', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      final file = files[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.insert_drive_file, color: Colors.blue),
                          title: Text(file.fileName),
                          trailing: const Icon(Icons.open_in_new),
                          onTap: () => _openFile(file.filePath),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                Text(context.l10n.alertLocation, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lat: ${alert.latitude.toStringAsFixed(6)}', style: const TextStyle(fontSize: 13)),
                        Text('Lng: ${alert.longitude.toStringAsFixed(6)}', style: const TextStyle(fontSize: 13)),
                        Text('${context.l10n.locationAccuracy}: ${Utils.formatAccuracy(alert.accuracy, context.l10n)}', 
                          style: TextStyle(fontSize: 13, color: Color(Utils.getAccuracyColor(alert.accuracy)))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Text('${context.l10n.messages} (${_messages.length})', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                if (_messages.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text(context.l10n.noMessages, style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  ..._messages.map((message) => _MessageBubble(message: message)),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 4, offset: const Offset(0, -2)),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: context.l10n.typeMessage,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(onPressed: _sendMessage, mini: true, child: const Icon(Icons.send)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: Colors.grey[600]),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isAdmin = message.isFromAdmin;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: isAdmin ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAdmin) ...[
            const CircleAvatar(radius: 16, backgroundColor: Colors.red, child: Icon(Icons.admin_panel_settings, size: 16, color: Colors.white)),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: isAdmin ? Colors.red : Colors.grey[300], borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message.message, style: TextStyle(color: isAdmin ? Colors.white : Colors.black)),
                  const SizedBox(height: 4),
                  Text(
                    Utils.formatTime(message.createdAt),
                    style: TextStyle(fontSize: 10, color: isAdmin ? Colors.white.withAlpha(180) : Colors.black.withAlpha(128)),
                  ),
                ],
              ),
            ),
          ),
          if (!isAdmin) ...[
            const SizedBox(width: 8),
            const CircleAvatar(radius: 16, backgroundColor: Colors.blue, child: Icon(Icons.person, size: 16, color: Colors.white)),
          ],
        ],
      ),
    );
  }
}
