import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'animated_quote_content.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

class QuoteCard extends StatefulWidget {
  final String text;
  final String author;
  final String? quoteId;

  const QuoteCard({
    super.key,
    required this.text,
    required this.author,
    this.quoteId,
  });

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> with TickerProviderStateMixin {
  bool _isLiked = false;
  bool _isBookmarked = false;
  AnimationController? _buttonAnimationController;
  Animation<double>? _buttonAnimation;
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _buttonAnimation = CurvedAnimation(
      parent: _buttonAnimationController!,
      curve: Curves.easeOut,
    );

    if (widget.quoteId != null) {
      _loadStates();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buttonAnimationController?.forward();
    });
  }

  @override
  void dispose() {
    _buttonAnimationController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant QuoteCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.quoteId != oldWidget.quoteId && widget.quoteId != null) {
      _loadStates();
    }
  }

  Future<void> _loadStates() async {
    if (!mounted) return;

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
      final results = await Future.wait([
        userDoc.collection('favorites').doc(widget.quoteId).get(),
        userDoc.collection('likes').doc(widget.quoteId).get(),
      ]);

      if (mounted) {
        setState(() {
          _isBookmarked = results[0].exists;
          _isLiked = results[1].exists;
        });
      }
    } catch (e) {
      debugPrint('Error loading states: $e');
    }
  }

  Future<void> _toggleBookmark() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || widget.quoteId == null) return;

    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    HapticFeedback.lightImpact();

    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .doc(widget.quoteId);

      if (!_isBookmarked) {
        await docRef.delete();
      } else {
        await docRef.set({
          'text': widget.text,
          'author': widget.author,
          'savedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('Error toggling bookmark: $e');
      if (mounted) {
        setState(() {
          _isBookmarked = !_isBookmarked;
        });
      }
      _showSnackBar('Failed to ${!_isBookmarked ? 'save' : 'remove'} quote');
    }
  }

  Future<void> _toggleLike() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || widget.quoteId == null) return;

    setState(() {
      _isLiked = !_isLiked;
    });

    HapticFeedback.lightImpact();

    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('likes')
          .doc(widget.quoteId);

      if (!_isLiked) {
        await docRef.delete();
      } else {
        await docRef.set({
          'text': widget.text,
          'author': widget.author,
          'likedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('Error toggling like: $e');
      if (mounted) {
        setState(() {
          _isLiked = !_isLiked;
        });
      }
      _showSnackBar('Failed to ${!_isLiked ? 'like' : 'unlike'} quote');
    }
  }

  void _copyQuote() {
    HapticFeedback.selectionClick();
    Clipboard.setData(
      ClipboardData(text: '"${widget.text}" - ${widget.author}'),
    );
    _showSnackBar('Quote copied to clipboard!');
  }

  Future<void> _shareQuote() async {
    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      final directory = await getTemporaryDirectory();
      final imagePath = File('${directory.path}/quote.png');
      await imagePath.writeAsBytes(image);

      await Share.shareXFiles(
        [XFile(imagePath.path)],
        subject: 'Quote',
      );
    } catch (e) {
      debugPrint("Error sharing quote: $e");
      _showSnackBar("Failed to share quote.");
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: isActive
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.onSurface.withOpacity(0.05),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isActive
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : Colors.transparent,
              border: Border.all(
                color: isActive
                    ? theme.colorScheme.primary.withOpacity(0.3)
                    : theme.colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceVariant.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: isDark ? 0 : -2,
          ),
          if (isDark)
            BoxShadow(
              color: Colors.white.withOpacity(0.05),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            // Wrap the content in a Container to capture the background
            Screenshot(
              controller: _screenshotController,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.surface,
                      theme.colorScheme.surfaceVariant.withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
                  child: AnimatedQuoteContent(
                    text: widget.text,
                    author: widget.author,
                  ),
                ),
              ),
            ),
            if (widget.quoteId != null) ...[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.5),
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.1),
                      width: 0.5,
                    ),
                  ),
                ),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(_buttonAnimation ??
                      const AlwaysStoppedAnimation(1.0)),
                  child: FadeTransition(
                    opacity: _buttonAnimation ??
                        const AlwaysStoppedAnimation(1.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                            label: 'Like',
                            isActive: _isLiked,
                            onTap: _toggleLike,
                          ),
                          _buildActionButton(
                            icon: Icons.copy_rounded,
                            label: 'Copy',
                            onTap: _copyQuote,
                          ),
                          _buildActionButton(
                            icon: _isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            label: 'Save',
                            isActive: _isBookmarked,
                            onTap: _toggleBookmark,
                          ),
                          _buildActionButton(
                            icon: Icons.share_rounded,
                            label: 'Share',
                            onTap: _shareQuote,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
