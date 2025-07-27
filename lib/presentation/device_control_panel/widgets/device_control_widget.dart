import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DeviceControlWidget extends StatefulWidget {
  final String deviceName;
  final String controlType;
  final bool initialValue;
  final double? sliderValue;
  final double? minValue;
  final double? maxValue;
  final String? unit;
  final Function(bool) onToggleChanged;
  final Function(double)? onSliderChanged;
  final bool isLoading;

  const DeviceControlWidget({
    Key? key,
    required this.deviceName,
    required this.controlType,
    required this.initialValue,
    this.sliderValue,
    this.minValue,
    this.maxValue,
    this.unit,
    required this.onToggleChanged,
    this.onSliderChanged,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<DeviceControlWidget> createState() => _DeviceControlWidgetState();
}

class _DeviceControlWidgetState extends State<DeviceControlWidget> {
  late bool _isActive;
  late double _currentSliderValue;

  @override
  void initState() {
    super.initState();
    _isActive = widget.initialValue;
    _currentSliderValue = widget.sliderValue ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.deviceName,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        widget.controlType,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                widget.isLoading
                    ? SizedBox(
                        width: 6.w,
                        height: 6.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      )
                    : Switch(
                        value: _isActive,
                        onChanged: (value) {
                          HapticFeedback.lightImpact();
                          setState(() {
                            _isActive = value;
                          });
                          widget.onToggleChanged(value);
                        },
                        activeColor: AppTheme.lightTheme.colorScheme.primary,
                        inactiveThumbColor: Colors.grey[400],
                        inactiveTrackColor: Colors.grey[300],
                      ),
              ],
            ),
            if (widget.sliderValue != null &&
                widget.onSliderChanged != null) ...[
              SizedBox(height: 2.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: _getControlIcon(),
                    color: _isActive
                        ? AppTheme.lightTheme.colorScheme.primary
                        : Colors.grey[400]!,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${widget.minValue?.toInt() ?? 0}${widget.unit ?? ''}',
                              style: AppTheme.lightTheme.textTheme.labelSmall,
                            ),
                            Text(
                              '${_currentSliderValue.toInt()}${widget.unit ?? ''}',
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: _isActive
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : Colors.grey[600],
                              ),
                            ),
                            Text(
                              '${widget.maxValue?.toInt() ?? 100}${widget.unit ?? ''}',
                              style: AppTheme.lightTheme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: _isActive
                                ? AppTheme.lightTheme.colorScheme.primary
                                : Colors.grey[400],
                            inactiveTrackColor: Colors.grey[300],
                            thumbColor: _isActive
                                ? AppTheme.lightTheme.colorScheme.primary
                                : Colors.grey[400],
                            overlayColor: AppTheme
                                .lightTheme.colorScheme.primary
                                .withValues(alpha: 0.2),
                            trackHeight: 1.h,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 3.w),
                          ),
                          child: Slider(
                            value: _currentSliderValue,
                            min: widget.minValue ?? 0.0,
                            max: widget.maxValue ?? 100.0,
                            divisions: ((widget.maxValue ?? 100.0) -
                                    (widget.minValue ?? 0.0))
                                .toInt(),
                            onChanged: _isActive
                                ? (value) {
                                    HapticFeedback.selectionClick();
                                    setState(() {
                                      _currentSliderValue = value;
                                    });
                                    widget.onSliderChanged!(value);
                                  }
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: _getStatusColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Container(
                    width: 2.w,
                    height: 2.w,
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    _getStatusText(),
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getControlIcon() {
    switch (widget.controlType.toLowerCase()) {
      case 'irrigation':
      case 'water':
        return 'water_drop';
      case 'drone':
        return 'flight';
      case 'sensor':
        return 'sensors';
      case 'actuator':
        return 'settings';
      default:
        return 'device_hub';
    }
  }

  Color _getStatusColor() {
    if (widget.isLoading) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    }
    return _isActive
        ? AppTheme.lightTheme.colorScheme.primary
        : Colors.grey[600]!;
  }

  String _getStatusText() {
    if (widget.isLoading) {
      return 'Processing...';
    }
    return _isActive ? 'Active' : 'Inactive';
  }
}
