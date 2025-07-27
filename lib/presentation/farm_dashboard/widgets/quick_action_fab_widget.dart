import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionFabWidget extends StatefulWidget {
  final VoidCallback? onIrrigationTap;
  final VoidCallback? onPestControlTap;
  final VoidCallback? onEmergencyTap;

  const QuickActionFabWidget({
    Key? key,
    this.onIrrigationTap,
    this.onPestControlTap,
    this.onEmergencyTap,
  }) : super(key: key);

  @override
  State<QuickActionFabWidget> createState() => _QuickActionFabWidgetState();
}

class _QuickActionFabWidgetState extends State<QuickActionFabWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _navigateToAgent(String route) {
    Navigator.pushNamed(context, route);
    _toggleExpanded();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            return _isExpanded
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: _expandAnimation.value,
                        child: _buildActionButton(
                          icon: 'gavel',
                          label: 'Policy Agent',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          onTap: () => _navigateToAgent('/policy-agent-chat'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Transform.scale(
                        scale: _expandAnimation.value,
                        child: _buildActionButton(
                          icon: 'help',
                          label: 'General Query Agent',
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          onTap: () =>
                              _navigateToAgent('/general-query-agent-chat'),
                        ),
                      ),
                      
                      SizedBox(height: 2.h),
                    ],
                  )
                : const SizedBox.shrink();
          },
        ),
        FloatingActionButton(
          onPressed: _toggleExpanded,
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 6,
          child: AnimatedRotation(
            turns: _isExpanded ? 0.125 : 0,
            duration: const Duration(milliseconds: 300),
            child: CustomIconWidget(
              iconName: _isExpanded ? 'close' : 'smart_toy',
              color: Colors.white,
              size: 6.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
