import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatusIndicatorsWidget extends StatelessWidget {
  final bool isGpsConnected;
  final bool isInternetConnected;
  final int batteryLevel;
  final String currentTime;

  const StatusIndicatorsWidget({
    Key? key,
    required this.isGpsConnected,
    required this.isInternetConnected,
    required this.batteryLevel,
    required this.currentTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildStatusIndicator(
                  icon: 'gps_fixed',
                  isActive: isGpsConnected,
                  activeColor: AppTheme.lightTheme.colorScheme.primary,
                  inactiveColor: AppTheme.lightTheme.colorScheme.error,
                ),
                SizedBox(width: 3.w),
                _buildStatusIndicator(
                  icon: 'wifi',
                  isActive: isInternetConnected,
                  activeColor: AppTheme.lightTheme.colorScheme.primary,
                  inactiveColor: AppTheme.lightTheme.colorScheme.error,
                ),
                SizedBox(width: 3.w),
                _buildBatteryIndicator(),
              ],
            ),
            Text(
              currentTime,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator({
    required String icon,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    return Container(
      padding: EdgeInsets.all(1.5.w),
      decoration: BoxDecoration(
        color: (isActive ? activeColor : inactiveColor).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: CustomIconWidget(
        iconName: icon,
        color: isActive ? activeColor : inactiveColor,
        size: 4.w,
      ),
    );
  }

  Widget _buildBatteryIndicator() {
    Color batteryColor;
    String batteryIcon;

    if (batteryLevel > 50) {
      batteryColor = AppTheme.lightTheme.colorScheme.primary;
      batteryIcon = 'battery_full';
    } else if (batteryLevel > 20) {
      batteryColor = AppTheme.lightTheme.colorScheme.tertiary;
      batteryIcon = 'battery_3_bar';
    } else {
      batteryColor = AppTheme.lightTheme.colorScheme.error;
      batteryIcon = 'battery_1_bar';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.w),
      decoration: BoxDecoration(
        color: batteryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: batteryIcon,
            color: batteryColor,
            size: 4.w,
          ),
          SizedBox(width: 1.w),
          Text(
            '$batteryLevel%',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: batteryColor,
              fontWeight: FontWeight.w600,
              fontSize: 9.sp,
            ),
          ),
        ],
      ),
    );
  }
}
