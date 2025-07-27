import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeatherHeroWidget extends StatefulWidget {
  final String temperature;
  final String condition;
  final String weatherIcon;

  const WeatherHeroWidget({
    super.key,
    required this.temperature,
    required this.condition,
    required this.weatherIcon,
  });

  @override
  State<WeatherHeroWidget> createState() => _WeatherHeroWidgetState();
}

class _WeatherHeroWidgetState extends State<WeatherHeroWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.lightTheme.colorScheme.tertiary
                            .withValues(alpha: 0.3),
                        AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15.w),
                  ),
                  child: CustomImageWidget(
                    imageUrl: widget.weatherIcon,
                    width: 25.w,
                    height: 25.w,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 3.h),
          Text(
            widget.temperature,
            style: AppTheme.lightTheme.textTheme.displayLarge?.copyWith(
              fontSize: 48.sp,
              fontWeight: FontWeight.w300,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            widget.condition,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.8),
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}
