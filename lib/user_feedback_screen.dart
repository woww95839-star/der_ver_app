import 'package:flutter/material.dart';
import 'feedback_model.dart';
import 'models.dart';
import 'database_helper.dart';
import 'utils.dart';
import 'context_extensions.dart';

class UserFeedbackScreen extends StatefulWidget {
  final User user;

  const UserFeedbackScreen({super.key, required this.user});

  @override
  State<UserFeedbackScreen> createState() => _UserFeedbackScreenState();
}

class _UserFeedbackScreenState extends State<UserFeedbackScreen> with SingleTickerProviderStateMixin {
  final _messageController = TextEditingController();
  List<FeedbackWithDetails> _feedbacks = [];
  bool _isLoading = true;
  bool _isSending = false;
  int _selectedRating = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _loadFeedbacks();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadFeedbacks() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final feedbacks = await DatabaseHelper.instance.getFeedbacksByUserId(widget.user.id!);
      List<FeedbackWithDetails> feedbacksWithDetails = feedbacks.map((f) => FeedbackWithDetails(
        feedback: f,
        user: widget.user,
      )).toList();

      if (mounted) {
        setState(() {
          _feedbacks = feedbacksWithDetails;
          _isLoading = false;
        });
        _animationController.forward(from: 0.0);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        context.showError('${context.l10n.error}: $e');
      }
    }
  }

  Future<void> _sendFeedback() async {
    final message = _messageController.text.trim();
    if (_selectedRating == 0) {
      context.showError(context.l10n.errorNoRating);
      return;
    }
    if (message.isEmpty || message.length < 10) {
      context.showError(context.l10n.errorFeedbackTooShort);
      return;
    }

    setState(() => _isSending = true);
    try {
      final feedback = UserFeedback(
        userId: widget.user.id!,
        message: message,
        rating: _selectedRating,
      );
      await DatabaseHelper.instance.createFeedback(feedback);
      _messageController.clear();
      setState(() => _selectedRating = 0);
      FocusScope.of(context).unfocus();
      if (mounted) context.showSuccess(context.l10n.successFeedbackSent);
      await _loadFeedbacks();
    } catch (e) {
      context.showError('${context.l10n.error}: $e');
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Widget _buildRatingBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final isSelected = index < _selectedRating;
        return IconButton(
          onPressed: () => setState(() => _selectedRating = index + 1),
          icon: AnimatedScale(
            scale: isSelected ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
              color: Colors.amber,
              size: 40,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar animée
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(context.l10n.feedback, style: const TextStyle(fontWeight: FontWeight.bold)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [context.colors.brand, context.colors.brand.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          // Formulaire d'envoi
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.rateApp, style: context.titleMedium?.bold),
                      _buildRatingBar(),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _messageController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: context.l10n.feedbackPlaceholder,
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isSending ? null : _sendFeedback,
                          icon: _isSending 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.send_rounded),
                          label: Text(context.l10n.submit),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(context.l10n.myFeedback, style: context.titleMedium?.bold),
            ),
          ),

          // Liste des feedbacks
          if (_isLoading)
            const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          else if (_feedbacks.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.feedback_outlined, size: 60, color: Colors.grey[300]),
                    const SizedBox(height: 10),
                    Text(context.l10n.noFeedback, style: TextStyle(color: Colors.grey[400])),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = _feedbacks[index];
                    return AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        final animationValue = Curves.easeOutQuart.transform(
                          (index * 0.1 + _animationController.value).clamp(0.0, 1.0),
                        );
                        return Opacity(
                          opacity: animationValue,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - animationValue)),
                            child: child,
                          ),
                        );
                      },
                      child: _FeedbackCard(item: item),
                    );
                  },
                  childCount: _feedbacks.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final FeedbackWithDetails item;
  const _FeedbackCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final f = item.feedback;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: f.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    f.status,
                    style: TextStyle(color: f.statusColor, fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ),
                const Spacer(),
                if (f.rating != null)
                  Row(children: List.generate(5, (i) => Icon(i < f.rating! ? Icons.star : Icons.star_border, color: Colors.amber, size: 14))),
              ],
            ),
            const SizedBox(height: 10),
            Text(f.message, style: const TextStyle(fontSize: 14)),
            if (f.adminReply != null) ...[
              const Divider(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.admin_panel_settings, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(context.l10n.adminReply, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(f.adminReply!, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(Utils.getRelativeTime(f.createdAt, context.l10n), style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ),
          ],
        ),
      ),
    );
  }
}
