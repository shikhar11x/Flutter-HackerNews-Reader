import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({super.key});

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ListView.builder(
          itemCount: 8,
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: AppTheme.cardWithAccent(),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left accent bar placeholder
                    Container(
                      width: 3,
                      decoration: BoxDecoration(
                        color: AppTheme.neonGreen.withOpacity(0.15),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: [
                                AppTheme.neonGreen.withOpacity(0.05),
                                AppTheme.neonGreen.withOpacity(0.2),
                                AppTheme.neonGreen.withOpacity(0.05),
                              ],
                              stops: [
                                (_animation.value - 1).clamp(0.0, 1.0),
                                _animation.value.clamp(0.0, 1.0),
                                (_animation.value + 1).clamp(0.0, 1.0),
                              ],
                            ).createShader(bounds);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 13,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppTheme.neonGreen.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                height: 13,
                                width: 180,
                                decoration: BoxDecoration(
                                  color: AppTheme.neonGreen.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    height: 10,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color:
                                          AppTheme.neonGreen.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    height: 10,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color:
                                          AppTheme.neonGreen.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    height: 10,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color:
                                          AppTheme.neonGreen.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}