import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../shared/models/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) _buildAvatar(Icons.smart_toy, const Color(0xFF0F6E56)),
          if (!isUser) const SizedBox(width: 8),
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF2D5A8E) : const Color(0xFF1E2128),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUser ? 18 : 4),
                  topRight: Radius.circular(isUser ? 4 : 18),
                  bottomLeft: const Radius.circular(18),
                  bottomRight: const Radius.circular(18),
                ),
                border: isUser ? null : Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: _buildContent(),
            ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.1, end: 0),
          ),
          
          if (isUser) const SizedBox(width: 8),
          if (isUser) _buildAvatar(Icons.person, const Color(0xFF2D5A8E)),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message.content,
          style: TextStyle(
            color: message.role == MessageRole.user ? Colors.white : Colors.white.withValues(alpha: 0.9),
            fontSize: 14,
            height: 1.4,
          ),
        ),
        if (message.isStreaming)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: _LoadingDots(),
          ),
      ],
    );
  }

  Widget _buildAvatar(IconData icon, Color bgColor) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: bgColor,
      child: Icon(icon, size: 16, color: Colors.white),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final progress = (_controller.value - delay) % 1.0;
            final opacity = (progress < 0 ? 0.0 : (progress < 0.5 ? progress * 2 : (1 - progress) * 2)).clamp(0.2, 1.0);
            
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: CircleAvatar(
                radius: 3,
                backgroundColor: Colors.white.withValues(alpha: opacity),
              ),
            );
          },
        );
      }),
    );
  }
}
