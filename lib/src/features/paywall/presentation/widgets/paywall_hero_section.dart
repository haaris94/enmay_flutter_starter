import 'package:enmay_flutter_starter/src/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PaywallHeroSection extends StatefulWidget {
  final String? heroImagePath;
  final String title;

  const PaywallHeroSection({
    super.key,
    this.heroImagePath,
    required this.title,
  });

  @override
  State<PaywallHeroSection> createState() => _PaywallHeroSectionState();
}

class _PaywallHeroSectionState extends State<PaywallHeroSection>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startShakeAnimation();
  }

  void _initializeAnimations() {
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 5.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 5.0, end: -5.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -5.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 0.95), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 0.9), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));
  }

  void _startShakeAnimation() {
    // Start shaking after a brief delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _performShake();
      }
    });
  }

  void _performShake() {
    _shakeController.forward().then((_) {
      if (mounted) {
        _shakeController.reset();
        // Repeat shake every ~1.3 seconds
        Future.delayed(const Duration(milliseconds: 1300), () {
          if (mounted) {
            _performShake();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hero Image with Shake Animation
        SizedBox(
          height: 150,
          child: Center(
            child: AnimatedBuilder(
              animation: _shakeController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: _buildHeroImage(context),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 32),
        
        // Title
        Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: context.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    // Check if custom image path is provided and exists
    if (widget.heroImagePath != null && widget.heroImagePath!.isNotEmpty) {
      return Image.asset(
        widget.heroImagePath!,
        height: 150,
        errorBuilder: (context, error, stackTrace) => _buildDefaultHeroIcon(context),
      );
    }

    return _buildDefaultHeroIcon(context);
  }

  Widget _buildDefaultHeroIcon(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.primary,
            context.primary.withOpacity(0.7),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: context.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        Icons.workspace_premium,
        size: 60,
        color: context.onPrimary,
      ),
    )
      .animate(onPlay: (controller) => controller.repeat(reverse: true))
      .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.3))
      .then(delay: 1000.ms)
      .scale(
        begin: const Offset(1.0, 1.0),
        end: const Offset(1.05, 1.05),
        duration: 1500.ms,
        curve: Curves.easeInOut,
      );
  }
}