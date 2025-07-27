import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DevicePairingDialog extends StatefulWidget {
  final VoidCallback? onQRScan;
  final VoidCallback? onManualEntry;

  const DevicePairingDialog({
    Key? key,
    this.onQRScan,
    this.onManualEntry,
  }) : super(key: key);

  @override
  State<DevicePairingDialog> createState() => _DevicePairingDialogState();
}

class _DevicePairingDialogState extends State<DevicePairingDialog> {
  final TextEditingController _deviceIdController = TextEditingController();
  final TextEditingController _deviceNameController = TextEditingController();
  bool _isManualEntry = false;

  @override
  void dispose() {
    _deviceIdController.dispose();
    _deviceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 90.w,
          maxHeight: 70.h,
        ),
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'device_hub',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Add New Device',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                    size: 5.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            // Content
            if (!_isManualEntry) ...[
              // QR Code scanning option
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'qr_code_scanner',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 12.w,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Scan QR Code',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Point your camera at the device QR code to automatically pair',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 2.h),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (widget.onQRScan != null) {
                          widget.onQRScan!();
                        }
                      },
                      icon: CustomIconWidget(
                        iconName: 'qr_code_scanner',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 4.w,
                      ),
                      label: Text('Start Scanning'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 1.5.h),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              // Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      'OR',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              // Manual entry option
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _isManualEntry = true;
                  });
                },
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 4.w,
                ),
                label: Text('Enter Device Details Manually'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  minimumSize: Size(double.infinity, 0),
                ),
              ),
            ] else ...[
              // Manual entry form
              Text(
                'Device Information',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: _deviceIdController,
                decoration: InputDecoration(
                  labelText: 'Device ID',
                  hintText: 'Enter device identifier',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'tag',
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                      size: 5.w,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: _deviceNameController,
                decoration: InputDecoration(
                  labelText: 'Device Name',
                  hintText: 'Enter a friendly name',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'label',
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                      size: 5.w,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _isManualEntry = false;
                          _deviceIdController.clear();
                          _deviceNameController.clear();
                        });
                      },
                      child: Text('Back'),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_deviceIdController.text.isNotEmpty &&
                            _deviceNameController.text.isNotEmpty) {
                          Navigator.of(context).pop();
                          if (widget.onManualEntry != null) {
                            widget.onManualEntry!();
                          }
                        }
                      },
                      child: Text('Add Device'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
