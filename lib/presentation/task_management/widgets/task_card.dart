import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class TaskCard extends StatefulWidget {
  final Map<String, dynamic> task;
  final Function(String) onTaskComplete;
  final Function(String) onTaskEdit;
  final Function(String) onTaskDelete;
  final Function(String) onTaskReschedule;
  final Function(String) onActionButtonPressed;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onTaskComplete,
    required this.onTaskEdit,
    required this.onTaskDelete,
    required this.onTaskReschedule,
    required this.onActionButtonPressed,
  }) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> with TickerProviderStateMixin {
  bool _isActionLoading = false;
  bool _isSelected = false;
  late AnimationController _slideController;
  late AnimationController _completeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _completeController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0.3, 0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _completeController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    _completeController.dispose();
    super.dispose();
  }

  Color _getPriorityColor() {
    final status = widget.task['status'] as String;
    final priority = widget.task['priority'] as String;

    if (status == 'completed') return AppTheme.lightTheme.colorScheme.primary;
    if (status == 'overdue') return AppTheme.lightTheme.colorScheme.error;
    if (priority == 'high') return AppTheme.lightTheme.colorScheme.tertiary;
    return AppTheme.lightTheme.colorScheme.outline;
  }

  IconData _getPriorityIcon() {
    final priority = widget.task['priority'] as String;
    switch (priority) {
      case 'high':
        return Icons.priority_high;
      case 'medium':
        return Icons.remove;
      case 'low':
        return Icons.keyboard_arrow_down;
      default:
        return Icons.remove;
    }
  }

  Future<void> _handleActionButton() async {
    if (_isActionLoading) return;

    setState(() => _isActionLoading = true);
    HapticFeedback.lightImpact();

    // Simulate IoT command execution
    await Future.delayed(Duration(milliseconds: 1500));

    widget.onActionButtonPressed(widget.task['id']);

    if (mounted) {
      setState(() => _isActionLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.task['actionLabel']} executed successfully'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleTaskComplete() {
    HapticFeedback.mediumImpact();
    _completeController.forward().then((_) {
      widget.onTaskComplete(widget.task['id']);
      _completeController.reverse();
    });
  }

  void _handleLongPress() {
    HapticFeedback.heavyImpact();
    setState(() => _isSelected = !_isSelected);
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final isCompleted = task['status'] == 'completed';
    final hasAction = task['actionLabel'] != null;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onLongPress: _handleLongPress,
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {
                // Swipe right - mark complete
                _handleTaskComplete();
              } else if (details.primaryVelocity! < 0) {
                // Swipe left - show options
                _slideController.forward();
                _showTaskOptions();
              }
            },
            child: AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset:
                      _slideAnimation.value * MediaQuery.of(context).size.width,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: _isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: _isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : Colors.transparent,
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.shadow,
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: _handleTaskComplete,
                                child: Container(
                                  width: 6.w,
                                  height: 6.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isCompleted
                                          ? AppTheme.lightTheme.colorScheme.primary
                                          : AppTheme.lightTheme.colorScheme.outline,
                                      width: 2.0,
                                    ),
                                    color: isCompleted
                                        ? AppTheme.lightTheme.colorScheme.primary
                                        : Colors.transparent,
                                  ),
                                  child: isCompleted
                                      ? CustomIconWidget(
                                          iconName: 'check',
                                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                                          size: 4.w,
                                        )
                                      : null,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task['title'] as String,
                                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                                        decoration: isCompleted
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        color: isCompleted
                                            ? AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6)
                                            : AppTheme.lightTheme.colorScheme.onSurface,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Row(
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'schedule',
                                          color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
                                          size: 3.5.w,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          task['dueDate'] as String,
                                          style: AppTheme.lightTheme.textTheme.bodySmall,
                                        ),
                                        Spacer(),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                          decoration: BoxDecoration(
                                            color: _getPriorityColor().withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomIconWidget(
                                                iconName: _getPriorityIcon().codePoint.toString(),
                                                color: _getPriorityColor(),
                                                size: 3.w,
                                              ),
                                              SizedBox(width: 1.w),
                                              Text(
                                                (task['priority'] as String).toUpperCase(),
                                                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                                                  color: _getPriorityColor(),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Delete icon button
                              IconButton(
                                icon: CustomIconWidget(
                                  iconName: 'delete',
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  size: 6.w,
                                ),
                                tooltip: 'Delete Task',
                                onPressed: () {
                                  widget.onTaskDelete(widget.task['id']);
                                },
                              ),
                            ],
                          ),
                          if (hasAction && !isCompleted) ...[
                            SizedBox(height: 2.h),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _isActionLoading
                                        ? null
                                        : _handleActionButton,
                                    icon: _isActionLoading
                                        ? SizedBox(
                                            width: 4.w,
                                            height: 4.w,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                AppTheme.lightTheme.colorScheme
                                                    .onPrimary,
                                              ),
                                            ),
                                          )
                                        : CustomIconWidget(
                                            iconName:
                                                task['actionIcon'] as String,
                                            color: AppTheme.lightTheme
                                                .colorScheme.onPrimary,
                                            size: 4.w,
                                          ),
                                    label: Text(
                                      _isActionLoading
                                          ? 'Executing...'
                                          : task['actionLabel'] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.labelLarge
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme
                                          .lightTheme.colorScheme.secondary,
                                      foregroundColor: AppTheme
                                          .lightTheme.colorScheme.onSecondary,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1.5.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showTaskOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              SizedBox(height: 3.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
                title: Text(
                  'Edit Task',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _slideController.reverse();
                  widget.onTaskEdit(widget.task['id']);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 6.w,
                ),
                title: Text(
                  'Reschedule',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _slideController.reverse();
                  widget.onTaskReschedule(widget.task['id']);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 6.w,
                ),
                title: Text(
                  'Delete Task',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _slideController.reverse();
                  widget.onTaskDelete(widget.task['id']);
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    ).then((_) {
      _slideController.reverse();
    });
  }
}
