import 'package:flutter/material.dart';
import 'feedback_model.dart';
import 'models.dart';
import 'database_helper.dart';
import 'utils.dart';
import 'context_extensions.dart';

class AdminFeedbackScreen extends StatefulWidget {
  const AdminFeedbackScreen({super.key});

  @override
  State<AdminFeedbackScreen> createState() => _AdminFeedbackScreenState();
}

class _AdminFeedbackScreenState extends State<AdminFeedbackScreen> with SingleTickerProviderStateMixin {
  List<FeedbackWithDetails> _feedbacks = [];
  bool _isLoading = true;
  String? _filterStatus;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _loadFeedbacks();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadFeedbacks() async {
    setState(() => _isLoading = true);

    try {
      final feedbacks = await DatabaseHelper.instance.getAllFeedbacks();

      List<FeedbackWithDetails> feedbacksWithDetails = [];
      for (var feedback in feedbacks) {
        if (_filterStatus != null && feedback.status != _filterStatus) {
          continue;
        }

        final user = await DatabaseHelper.instance.getUserById(feedback.userId);
        if (user != null) {
          feedbacksWithDetails.add(FeedbackWithDetails(
            feedback: feedback,
            user: user,
          ));
        }
      }

      setState(() {
        _feedbacks = feedbacksWithDetails;
        _isLoading = false;
      });
      _animationController.forward(from: 0.0);
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('${context.l10n.error}: $e');
    }
  }

  String _getLocalizedStatus(String status) {
    switch (status) {
      case 'pending':
        return context.l10n.feedbackStatusPending;
      case 'read':
        return context.l10n.feedbackStatusRead;
      case 'replied':
        return context.l10n.feedbackStatusReplied;
      default:
        return status;
    }
  }

  void _showReplyDialog(FeedbackWithDetails item) {
    final replyController = TextEditingController(text: item.feedback.adminReply ?? '');

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(context.l10n.replyToFeedback, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: context.colors.brand.withOpacity(0.1),
                  radius: 18,
                  child: Icon(Icons.person, size: 18, color: context.colors.brand),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.user.fullName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.feedback.rating != null)
                  Row(
                    children: List.generate(5, (i) => Icon(
                      i < item.feedback.rating! ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 14,
                    )),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(item.feedback.message, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: replyController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: context.l10n.yourReply,
                hintText: context.l10n.replyHint,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel, style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () async {
              final reply = replyController.text.trim();
              if (reply.isNotEmpty) {
                try {
                  await DatabaseHelper.instance.replyToFeedback(
                    item.feedback.id!,
                    reply,
                  );

                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.successReplyAdded),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                    _loadFeedbacks();
                  }
                } catch (e) {
                  _showError('${context.l10n.error}: $e');
                }
              }
            },
            child: Text(context.l10n.submit),
          ),
        ],
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: child,
          ),
        );
      },
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Text(context.l10n.filterByStatus, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildFilterOption(null, context.l10n.all, Icons.list),
            _buildFilterOption('pending', context.l10n.feedbackStatusPending, Icons.pending_actions, Colors.orange),
            _buildFilterOption('read', context.l10n.feedbackStatusRead, Icons.mark_email_read, Colors.blue),
            _buildFilterOption('replied', context.l10n.feedbackStatusReplied, Icons.reply_all, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String? value, String title, IconData icon, [Color? color]) {
    final isSelected = _filterStatus == value;
    return ListTile(
      leading: Icon(icon, color: isSelected ? (color ?? context.colors.brand) : Colors.grey),
      title: Text(title, style: TextStyle(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? (color ?? context.colors.brand) : null,
      )),
      trailing: isSelected ? Icon(Icons.check_circle, color: color ?? context.colors.brand) : null,
      onTap: () {
        setState(() => _filterStatus = value);
        Navigator.pop(context);
        _loadFeedbacks();
      },
    );
  }

  Future<void> _markAsRead(int feedbackId) async {
    try {
      await DatabaseHelper.instance.updateFeedbackStatus(feedbackId, 'read');
      _loadFeedbacks();
    } catch (e) {
      _showError('${context.l10n.error}: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message), 
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [context.colors.brand, context.colors.brand.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.userFeedbacks, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (_feedbacks.isNotEmpty)
              Text(
                context.l10n.countFeedbacks(_feedbacks.length),
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadFeedbacks,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _feedbacks.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.feedback_outlined, size: 100, color: Colors.grey[300]),
            const SizedBox(height: 20),
            Text(
              _filterStatus != null ? context.l10n.noAlertsFiltered : context.l10n.noFeedback,
              style: TextStyle(fontSize: 18, color: Colors.grey[400], fontWeight: FontWeight.w500),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadFeedbacks,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _feedbacks.length,
          itemBuilder: (context, index) {
            final item = _feedbacks[index];
            final feedback = item.feedback;
            final user = item.user;

            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final delay = index * 0.1;
                final animationValue = Curves.easeOutCubic.transform(
                  ( _animationController.value - delay).clamp(0.0, 1.0),
                );
                return Opacity(
                  opacity: animationValue,
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - animationValue)),
                    child: child,
                  ),
                );
              },
              child: Card(
                elevation: 3,
                shadowColor: Colors.black12,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: InkWell(
                  onTap: () {
                    if (feedback.status == 'pending') {
                      _markAsRead(feedback.id!);
                    }
                    _showReplyDialog(item);
                  },
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: context.colors.brand.withOpacity(0.2), width: 2),
                              ),
                              child: CircleAvatar(
                                backgroundColor: context.colors.brand.withOpacity(0.1),
                                child: Text(
                                  user.prenom.isNotEmpty ? user.prenom[0].toUpperCase() : '?',
                                  style: TextStyle(color: context.colors.brand, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.fullName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  Text(
                                    user.phone,
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: feedback.statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _getLocalizedStatus(feedback.status),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: feedback.statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (feedback.rating != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: List.generate(5, (i) => Icon(
                                      i < feedback.rating! ? Icons.star : Icons.star_border,
                                      color: Colors.amber,
                                      size: 16,
                                    )),
                                  ),
                                ),
                              Text(
                                feedback.message,
                                style: const TextStyle(height: 1.4, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey[400]),
                            const SizedBox(width: 5),
                            Text(
                              Utils.getRelativeTime(feedback.createdAt, context.l10n),
                              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                            ),
                            const Spacer(),
                            if (feedback.adminReply != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle, size: 12, color: Colors.green),
                                    const SizedBox(width: 4),
                                    Text(
                                      context.l10n.feedbackStatusReplied,
                                      style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            else
                              Text(
                                context.isArabic ? 'بانتظار الرد' : 'Awaiting reply',
                                style: TextStyle(fontSize: 11, color: Colors.orange[700], fontStyle: FontStyle.italic),
                              ),
                          ],
                        ),
                      ],
                    ),
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
