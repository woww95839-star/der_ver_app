import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'models.dart';
import 'database_helper.dart';
import 'utils.dart';
import 'context_extensions.dart';

class AlertDetailScreen extends StatefulWidget {
  final int alertId;
  final User currentUser;

  const AlertDetailScreen({
    super.key,
    required this.alertId,
    required this.currentUser,
  });

  @override
  State<AlertDetailScreen> createState() => _AlertDetailScreenState();
}

class _AlertDetailScreenState extends State<AlertDetailScreen> {
  AlertWithDetails? _alertWithDetails;
  List<Message> _messages = [];
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = true;
  bool _isSending = false;

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        _loadData();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final alertWithDetails = await DatabaseHelper.instance.getAlertWithDetails(widget.alertId);
      final messages = await DatabaseHelper.instance.getMessagesByAlertId(widget.alertId);

      if (!mounted) return;

      setState(() {
        _alertWithDetails = alertWithDetails;
        _messages = messages;
        _isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('Error: $e');
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);

    try {
      final message = Message(
        alertId: widget.alertId,
        senderRole: widget.currentUser.role,
        message: text,
      );

      await DatabaseHelper.instance.createMessage(message);
      _messageController.clear();
      FocusScope.of(context).unfocus();
      await _loadData();

      if (mounted) {
        context.showSuccess(context.l10n.successMessageSent);
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    context.showError(message);
  }

  Future<void> _openFile(String filePath) async {
    try {
      final result = await OpenFilex.open(filePath);
      if (result.type != ResultType.done) {
        _showError('Could not open file: ${result.message}');
      }
    } catch (e) {
      _showError('Error opening file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _alertWithDetails == null) {
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
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              controller: _scrollController,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(alert.type, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue[700])),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: alert.statusColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(alert.getStatusLabel(context.l10n), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: alert.statusColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // User Info
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(
                        user.prenom.isNotEmpty ? user.prenom[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white)
                      ),
                    ),
                    title: Text(user.fullName),
                    subtitle: Text(user.phone),
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                Text(context.l10n.alertDescription, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(alert.description),
                const SizedBox(height: 16),

                // Photos
                if (photos.isNotEmpty) ...[
                  Text('${context.l10n.alertPhotos} (${photos.length})', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: photos.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _showPhotoDialog(photos[index].photoPath),
                          child: Container(
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
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Files
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

                // Location
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
                const SizedBox(height: 16),

                // Date
                Text(context.l10n.alertDate, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(Utils.formatDateTime(alert.createdAt)),
                const SizedBox(height: 24),

                // Messages
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
                  ..._messages.map((message) => _MessageBubble(
                    message: message,
                    isCurrentUser: message.senderRole == widget.currentUser.role,
                  )),
              ],
            ),
          ),

          // Input zone
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
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
                    enabled: !_isSending,
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _isSending ? null : _sendMessage,
                  mini: true,
                  backgroundColor: _isSending ? Colors.grey : const Color(0xFFD32F2F),
                  child: _isSending
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPhotoDialog(String photoPath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(File(photoPath)),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.close),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isCurrentUser;

  const _MessageBubble({required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (!isCurrentUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.red,
              child: Icon(Icons.admin_panel_settings, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isCurrentUser ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message.message, style: TextStyle(color: isCurrentUser ? Colors.white : Colors.black)),
                  const SizedBox(height: 4),
                  Text(
                    Utils.formatTime(message.createdAt),
                    style: TextStyle(
                      fontSize: 10,
                      color: isCurrentUser ? Colors.white.withAlpha(180) : Colors.black.withAlpha(128),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isCurrentUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}
