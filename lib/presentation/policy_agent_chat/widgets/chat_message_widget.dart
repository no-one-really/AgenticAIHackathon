import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatMessageWidget extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final String? agentType;

  const ChatMessageWidget({
    Key? key,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.agentType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _buildAvatar(),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: isUser
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomLeft: isUser
                      ? const Radius.circular(18)
                      : const Radius.circular(4),
                  bottomRight: isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(18),
                ),
                border: isUser
                    ? null
                    : Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                      ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: isUser
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _formatTime(timestamp),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: isUser
                          ? Colors.white.withValues(alpha: 0.7)
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 2.w),
            CircleAvatar(
              radius: 4.w,
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              child: CustomIconWidget(
                iconName: 'person',
                color: Colors.white,
                size: 4.w,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    Color avatarColor;
    String iconName;

    switch (agentType) {
      case 'policy':
        avatarColor = AppTheme.lightTheme.colorScheme.primary;
        iconName = 'gavel';
        break;
      case 'general':
        avatarColor = AppTheme.lightTheme.colorScheme.tertiary;
        iconName = 'help';
        break;
      case 'iot':
        avatarColor = const Color(0xFF4CAF50);
        iconName = 'devices';
        break;
      default:
        avatarColor = AppTheme.lightTheme.colorScheme.primary;
        iconName = 'smart_toy';
    }

    return CircleAvatar(
      radius: 4.w,
      backgroundColor: avatarColor,
      child: CustomIconWidget(
        iconName: iconName,
        color: Colors.white,
        size: 4.w,
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
