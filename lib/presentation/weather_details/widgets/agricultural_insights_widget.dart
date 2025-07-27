import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AgriculturalInsightsWidget extends StatelessWidget {
  final Map<String, dynamic> insightsData;

  const AgriculturalInsightsWidget({
    super.key,
    required this.insightsData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'agriculture',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Agricultural Insights',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildInsightCard(
            'Optimal Spraying Time',
            insightsData['sprayingTime'] as String,
            insightsData['sprayingAdvice'] as String,
            'spray_tan',
            AppTheme.lightTheme.colorScheme.tertiary,
          ),
          SizedBox(height: 2.h),
          _buildInsightCard(
            'Irrigation Recommendation',
            insightsData['irrigationStatus'] as String,
            insightsData['irrigationAdvice'] as String,
            'water_drop',
            AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          _buildInsightCard(
            'Harvest Advisory',
            insightsData['harvestStatus'] as String,
            insightsData['harvestAdvice'] as String,
            'grass',
            AppTheme.lightTheme.colorScheme.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(
    String title,
    String status,
    String advice,
    String iconName,
    Color iconColor,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
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
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: iconColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      status,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: iconColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            advice,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
