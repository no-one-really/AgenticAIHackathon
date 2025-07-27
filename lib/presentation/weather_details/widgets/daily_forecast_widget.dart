import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DailyForecastWidget extends StatefulWidget {
  final List<Map<String, dynamic>> dailyData;

  const DailyForecastWidget({
    super.key,
    required this.dailyData,
  });

  @override
  State<DailyForecastWidget> createState() => _DailyForecastWidgetState();
}

class _DailyForecastWidgetState extends State<DailyForecastWidget> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '7-Day Forecast',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.dailyData.length,
            itemBuilder: (context, index) {
              final day = widget.dailyData[index];
              final isExpanded = expandedIndex == index;

              return Container(
                margin: EdgeInsets.only(bottom: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          expandedIndex = isExpanded ? null : index;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                day['day'] as String,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                            CustomImageWidget(
                              imageUrl: day['icon'] as String,
                              width: 10.w,
                              height: 10.w,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: 3.w),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'water_drop',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 16,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  '${day['precipitation']}%',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${day['high']}°/${day['low']}°',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            CustomIconWidget(
                              iconName:
                                  isExpanded ? 'expand_less' : 'expand_more',
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isExpanded) ...[
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                      ),
                      Container(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hourly Breakdown',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.8),
                              ),
                            ),
                            SizedBox(height: 1.h),
                            SizedBox(
                              height: 12.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    (day['hourlyBreakdown'] as List).length,
                                itemBuilder: (context, hourIndex) {
                                  final hourData = (day['hourlyBreakdown']
                                      as List)[hourIndex];
                                  return Container(
                                    width: 15.w,
                                    margin: EdgeInsets.only(right: 2.w),
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.surface
                                          .withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          hourData['time'] as String,
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            fontSize: 9.sp,
                                          ),
                                        ),
                                        CustomImageWidget(
                                          imageUrl: hourData['icon'] as String,
                                          width: 6.w,
                                          height: 6.w,
                                          fit: BoxFit.contain,
                                        ),
                                        Text(
                                          '${hourData['temp']}°',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
