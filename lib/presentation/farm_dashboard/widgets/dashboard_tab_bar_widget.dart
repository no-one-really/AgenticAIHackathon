import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DashboardTabBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final TabController tabController;
  final List<String> tabs;
  final Function(int) onTabChanged;

  const DashboardTabBarWidget({
    Key? key,
    required this.tabController,
    required this.tabs,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.lightTheme.scaffoldBackgroundColor,
      child: TabBar(
        controller: tabController,
        tabs: tabs.map((tab) => _buildTab(tab)).toList(),
        onTap: onTabChanged,
        labelColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedLabelColor:
            AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorColor: AppTheme.lightTheme.colorScheme.primary,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
        ),
        unselectedLabelStyle:
            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 11.sp,
        ),
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        labelPadding: EdgeInsets.symmetric(horizontal: 1.w),
      ),
    );
  }

  Widget _buildTab(String title) {
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: _getTabIcon(title),
              color: tabController.index == tabs.indexOf(title)
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              size: 4.w,
            ),
            SizedBox(width: 1.w),
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTabIcon(String title) {
    switch (title.toLowerCase()) {
      case 'dashboard':
        return 'dashboard';
      case 'iot hub':
        return 'hub';
      case 'tasks':
        return 'task_alt';
      case 'settings':
        return 'settings';
      default:
        return 'tab';
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(8.h);
}
