import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8.0,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 8.h,
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
            unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.6),
            selectedLabelStyle:
                AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelSmall,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 0.5.h),
                  child: CustomIconWidget(
                    iconName: 'dashboard',
                    color: currentIndex == 0
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                    size: 6.w,
                  ),
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 0.5.h),
                  child: CustomIconWidget(
                    iconName: 'hub',
                    color: currentIndex == 1
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                    size: 6.w,
                  ),
                ),
                label: 'IoT Hub',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 0.5.h),
                  child: CustomIconWidget(
                    iconName: 'task_alt',
                    color: currentIndex == 2
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                    size: 6.w,
                  ),
                ),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 0.5.h),
                  child: CustomIconWidget(
                    iconName: 'wb_sunny',
                    color: currentIndex == 3
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                    size: 6.w,
                  ),
                ),
                label: 'Weather',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 0.5.h),
                  child: CustomIconWidget(
                    iconName: 'settings',
                    color: currentIndex == 4
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                    size: 6.w,
                  ),
                ),
                label: 'Control',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
