import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RippleSebhaButton extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;
  final bool isCompleted;

  const RippleSebhaButton({
    super.key,
    required this.onTap,
    required this.child,
    this.isCompleted = false,
  });

  @override
  State<RippleSebhaButton> createState() => _RippleSebhaButtonState();
}

class _RippleSebhaButtonState extends State<RippleSebhaButton> with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  
  void _handleTap() {
    if (widget.isCompleted) return;
    
    // Haptic Feedback for physical satisfaction
    HapticFeedback.mediumImpact();
    widget.onTap();

    // Trigger Ripple
    final controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _controllers.add(controller);
    controller.forward().then((_) {
      if (mounted) {
        setState(() {
          _controllers.remove(controller);
        });
      }
      controller.dispose();
    });
    setState(() {});
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Render Ripples
          ..._controllers.map((controller) {
            return AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (controller.value * 0.4),
                  child: Opacity(
                    opacity: (1.0 - controller.value).clamp(0.0, 1.0),
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
          // Render Main Content
          widget.child,
        ],
      ),
    );
  }
}
