import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeatherMetricsWidget extends StatelessWidget {
  final Map<String, dynamic> metricsData;

  const WeatherMetricsWidget({
    super.key,
    required this.metricsData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weather Details',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            children: [
              _buildMetricCard(
                'Humidity',
                '${metricsData['humidity']}%',
                'water_drop',
                AppTheme.lightTheme.colorScheme.primary,
              ),
              _buildMetricCard(
                'UV Index',
                '${metricsData['uvIndex']}',
                'wb_sunny',
                AppTheme.lightTheme.colorScheme.tertiary,
              ),
              _buildMetricCard(
                'Visibility',
                '${metricsData['visibility']} km',
                'visibility',
                AppTheme.lightTheme.colorScheme.secondary,
              ),
              _buildMetricCard(
                'Pressure',
                '${metricsData['pressure']} hPa',
                'speed',
                AppTheme.lightTheme.colorScheme.onSurface,
              ),
              _buildMetricCard(
                'Sunrise',
                metricsData['sunrise'] as String,
                'wb_sunny',
                AppTheme.lightTheme.colorScheme.tertiary,
              ),
              _buildMetricCard(
                'Sunset',
                metricsData['sunset'] as String,
                'brightness_3',
                AppTheme.lightTheme.colorScheme.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, String iconName, Color iconColor) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: iconColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
