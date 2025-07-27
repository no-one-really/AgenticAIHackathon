import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DeviceCardWidget extends StatefulWidget {
  final Map<String, dynamic> device;
  final VoidCallback? onTap;
  final VoidCallback? onCalibrate;
  final VoidCallback? onRename;
  final VoidCallback? onSetAlerts;
  final VoidCallback? onDisconnect;

  const DeviceCardWidget({
    Key? key,
    required this.device,
    this.onTap,
    this.onCalibrate,
    this.onRename,
    this.onSetAlerts,
    this.onDisconnect,
  }) : super(key: key);

  @override
  State<DeviceCardWidget> createState() => _DeviceCardWidgetState();
}

class _DeviceCardWidgetState extends State<DeviceCardWidget>
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
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  Color _getSignalColor(int strength) {
    if (strength >= 80) return AppTheme.lightTheme.colorScheme.primary;
    if (strength >= 60) return AppTheme.lightTheme.colorScheme.tertiary;
    return AppTheme.lightTheme.colorScheme.error;
  }

  Color _getBatteryColor(int level) {
    if (level >= 50) return AppTheme.lightTheme.colorScheme.primary;
    if (level >= 20) return AppTheme.lightTheme.colorScheme.tertiary;
    return AppTheme.lightTheme.colorScheme.error;
  }

  Color _getValueColor(String type, double value) {
    switch (type.toLowerCase()) {
      case 'soil ph':
        if (value >= 6.0 && value <= 7.5)
          return AppTheme.lightTheme.colorScheme.primary;
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'moisture':
        if (value >= 40 && value <= 80)
          return AppTheme.lightTheme.colorScheme.primary;
        if (value >= 20) return AppTheme.lightTheme.colorScheme.tertiary;
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = widget.device['type'] as String? ?? 'Unknown';
    final deviceName = widget.device['name'] as String? ?? 'Unnamed Device';
    final batteryLevel = widget.device['batteryLevel'] as int? ?? 0;
    final signalStrength = widget.device['signalStrength'] as int? ?? 0;
    final primaryValue = widget.device['primaryValue'] as double? ?? 0.0;
    final primaryUnit = widget.device['primaryUnit'] as String? ?? '';
    final isOnline = widget.device['isOnline'] as bool? ?? false;
    final lastUpdate = widget.device['lastUpdate'] as String? ?? 'Never';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: _toggleExpanded,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              // Main card content
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      children: [
                        // Device icon
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: _getDeviceIcon(deviceType),
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 6.w,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        // Device info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                deviceName,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                deviceType,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Status indicators
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Online status
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: isOnline
                                    ? AppTheme.lightTheme.colorScheme.primary
                                        .withValues(alpha: 0.1)
                                    : AppTheme.lightTheme.colorScheme.error
                                        .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isOnline ? 'Online' : 'Offline',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: isOnline
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme.lightTheme.colorScheme.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 1.h),
                            // Expand icon
                            CustomIconWidget(
                              iconName:
                                  _isExpanded ? 'expand_less' : 'expand_more',
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              size: 5.w,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    // Primary value display
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: _getValueColor(deviceType, primaryValue)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  deviceType == 'Soil pH Sensor'
                                      ? 'pH Level'
                                      : deviceType == 'Moisture Sensor'
                                          ? 'Moisture'
                                          : 'Value',
                                  style:
                                      AppTheme.lightTheme.textTheme.labelMedium,
                                ),
                                SizedBox(height: 0.5.h),
                                Row(
                                  children: [
                                    Text(
                                      primaryValue.toStringAsFixed(1),
                                      style: AppTheme
                                          .lightTheme.textTheme.headlineSmall
                                          ?.copyWith(
                                        color: _getValueColor(
                                            deviceType, primaryValue),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      primaryUnit,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: _getValueColor(
                                            deviceType, primaryValue),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        // Battery and signal
                        Column(
                          children: [
                            // Battery
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'battery_std',
                                  color: _getBatteryColor(batteryLevel),
                                  size: 4.w,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  '$batteryLevel%',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: _getBatteryColor(batteryLevel),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            // Signal
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'signal_cellular_4_bar',
                                  color: _getSignalColor(signalStrength),
                                  size: 4.w,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  '$signalStrength%',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: _getSignalColor(signalStrength),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Expanded content
              SizeTransition(
                sizeFactor: _expandAnimation,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                        height: 1,
                      ),
                      SizedBox(height: 2.h),
                      // Last update
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'access_time',
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Last update: $lastUpdate',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: widget.onCalibrate,
                              icon: CustomIconWidget(
                                iconName: 'tune',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 4.w,
                              ),
                              label: Text('Calibrate'),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: widget.onSetAlerts,
                              icon: CustomIconWidget(
                                iconName: 'notifications',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 4.w,
                              ),
                              label: Text('Alerts'),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton.icon(
                              onPressed: widget.onRename,
                              icon: CustomIconWidget(
                                iconName: 'edit',
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                size: 4.w,
                              ),
                              label: Text('Rename'),
                            ),
                          ),
                          Expanded(
                            child: TextButton.icon(
                              onPressed: widget.onDisconnect,
                              icon: CustomIconWidget(
                                iconName: 'link_off',
                                color: AppTheme.lightTheme.colorScheme.error,
                                size: 4.w,
                              ),
                              label: Text(
                                'Disconnect',
                                style: TextStyle(
                                  color: AppTheme.lightTheme.colorScheme.error,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDeviceIcon(String deviceType) {
    switch (deviceType.toLowerCase()) {
      case 'soil ph sensor':
        return 'science';
      case 'moisture sensor':
        return 'water_drop';
      case 'weather station':
        return 'cloud';
      case 'camera':
        return 'camera_alt';
      case 'actuator':
        return 'settings_input_component';
      default:
        return 'device_hub';
    }
  }
}
