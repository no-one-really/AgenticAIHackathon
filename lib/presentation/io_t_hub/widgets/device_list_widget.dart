import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './device_card_widget.dart';

class DeviceListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> devices;
  final VoidCallback? onRefresh;
  final Function(Map<String, dynamic>)? onDeviceCalibrate;
  final Function(Map<String, dynamic>)? onDeviceRename;
  final Function(Map<String, dynamic>)? onDeviceSetAlerts;
  final Function(Map<String, dynamic>)? onDeviceDisconnect;

  const DeviceListWidget({
    Key? key,
    required this.devices,
    this.onRefresh,
    this.onDeviceCalibrate,
    this.onDeviceRename,
    this.onDeviceSetAlerts,
    this.onDeviceDisconnect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (onRefresh != null) {
          onRefresh!();
        }
        // Add haptic feedback
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          top: 1.h,
          bottom: 10.h, // Space for FAB
        ),
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return Dismissible(
            key: Key(device['id'].toString()),
            background: _buildSwipeBackground(isLeft: true),
            secondaryBackground: _buildSwipeBackground(isLeft: false),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                // Swipe left - disconnect
                return await _showDisconnectDialog(context, device);
              } else {
                // Swipe right - quick actions
                _showQuickActions(context, device);
                return false;
              }
            },
            child: DeviceCardWidget(
              device: device,
              onCalibrate: () {
                if (onDeviceCalibrate != null) {
                  onDeviceCalibrate!(device);
                }
              },
              onRename: () {
                if (onDeviceRename != null) {
                  onDeviceRename!(device);
                }
              },
              onSetAlerts: () {
                if (onDeviceSetAlerts != null) {
                  onDeviceSetAlerts!(device);
                }
              },
              onDisconnect: () {
                if (onDeviceDisconnect != null) {
                  onDeviceDisconnect!(device);
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'device_hub',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.3),
              size: 20.w,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Devices Connected',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Add your first IoT device to start monitoring your farm',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 5.w,
              ),
              label: Text('Add Device'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'tune' : 'link_off',
                color: isLeft
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
              SizedBox(height: 1.h),
              Text(
                isLeft ? 'Actions' : 'Disconnect',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: isLeft
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showDisconnectDialog(
      BuildContext context, Map<String, dynamic> device) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Disconnect Device'),
            content: Text(
              'Are you sure you want to disconnect "${device['name']}"? This will stop monitoring and remove the device from your hub.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  if (onDeviceDisconnect != null) {
                    onDeviceDisconnect!(device);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
                child: Text('Disconnect'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showQuickActions(BuildContext context, Map<String, dynamic> device) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'tune',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              title: Text('Calibrate Device'),
              onTap: () {
                Navigator.of(context).pop();
                if (onDeviceCalibrate != null) {
                  onDeviceCalibrate!(device);
                }
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              title: Text('Rename Device'),
              onTap: () {
                Navigator.of(context).pop();
                if (onDeviceRename != null) {
                  onDeviceRename!(device);
                }
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'notifications',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              title: Text('Set Alerts'),
              onTap: () {
                Navigator.of(context).pop();
                if (onDeviceSetAlerts != null) {
                  onDeviceSetAlerts!(device);
                }
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
