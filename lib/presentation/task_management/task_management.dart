import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_task_modal.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/task_card.dart';
import './widgets/task_filter_chips.dart';

class TaskManagement extends StatefulWidget {
  const TaskManagement({Key? key}) : super(key: key);

  @override
  State<TaskManagement> createState() => _TaskManagementState();
}

class _TaskManagementState extends State<TaskManagement>
    with TickerProviderStateMixin {
  String _selectedFilter = 'Today';
  List<String> _selectedTaskIds = [];
  bool _isSelectionMode = false;
  late AnimationController _refreshController;
  late Animation<double> _refreshAnimation;

  // Mock task data
  List<Map<String, dynamic>> _allTasks = [
    {
      "id": "1",
      "title": "Spray pesticide on tomato field",
      "description":
          "Apply organic pesticide to prevent pest infestation in the north tomato field",
      "priority": "high",
      "dueDate": "26/07/2025",
      "status": "pending",
      "createdAt": "2025-07-25T10:30:00Z",
      "actionLabel": "Trigger Drones",
      "actionIcon": "flight",
    },

    {
      "id": "2",
      "title": "check market price",
      "description":
      "Logictics has been arranged for loading harvested produce from the farm",
      "priority": "medium",
      "dueDate": "27/07/2025",

      "status": "pending",
      "createdAt": "2025-07-24T14:20:00Z",
    },
    {
      "id": "3",
      "title": "Harvest wheat field A",
      "description": "Harvest mature wheat from the eastern field section",
      "priority": "high",
      "dueDate": "25/07/2025",
      "status": "overdue",
      "createdAt": "2025-07-20T09:00:00Z",
    },

    {
      "id": "4",
      "title": "Load Produce",
      "description": "Activate irrigation system for greenhouse vegetables",
      "priority": "medium",
      "dueDate": "26/07/2025",
      "status": "pending",
      "createdAt": "2025-07-25T08:15:00Z",
      "actionLabel": "Book Transport",
      "actionIcon": "power",
    },
    {
      "id": "5",
      "title": "Apply fertilizer to corn",
      "description": "Spread nitrogen-rich fertilizer across corn plantation",
      "priority": "low",
      "dueDate": "28/07/2025",
      "status": "pending",
      "createdAt": "2025-07-25T16:45:00Z",
      "actionLabel": "Activate Spreader",
      "actionIcon": "scatter_plot",
    },
    {
      "id": "6",
      "title": "Check irrigation system",
      "description": "Inspect and maintain drip irrigation components",
      "priority": "medium",
      "dueDate": "24/07/2025",
      "status": "completed",
      "createdAt": "2025-07-23T11:30:00Z",
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredTasks {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekFromNow = today.add(Duration(days: 7));

    return _allTasks.where((task) {
      final taskDateParts = (task['dueDate'] as String).split('/');
      final taskDate = DateTime(
        int.parse(taskDateParts[2]),
        int.parse(taskDateParts[1]),
        int.parse(taskDateParts[0]),
      );

      switch (_selectedFilter) {
        case 'Today':
          return taskDate.isAtSameMomentAs(today) ||
              taskDate.isBefore(today.add(Duration(days: 1)));
        case 'This Week':
          return taskDate.isBefore(weekFromNow) &&
              taskDate.isAfter(today.subtract(Duration(days: 1)));
        case 'Overdue':
          return task['status'] == 'overdue' ||
              (taskDate.isBefore(today) && task['status'] != 'completed');
        default:
          return true;
      }
    }).toList();
  }

  void _handleFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
      _isSelectionMode = false;
      _selectedTaskIds.clear();
    });
  }

  void _handleTaskComplete(String taskId) {
    HapticFeedback.mediumImpact();
    setState(() {
      final taskIndex = _allTasks.indexWhere((task) => task['id'] == taskId);
      if (taskIndex != -1) {
        _allTasks[taskIndex]['status'] = 'completed';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task completed successfully!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleTaskEdit(String taskId) {
    // Navigate to edit task screen or show edit modal
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit task functionality - Coming soon!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleTaskDelete(String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Task'),
        content: Text(
            'Are you sure you want to delete this task? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allTasks.removeWhere((task) => task['id'] == taskId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Task deleted successfully'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleTaskReschedule(String taskId) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              headerBackgroundColor: AppTheme.lightTheme.colorScheme.primary,
              headerForegroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
            ),
          ),
          child: child!,
        );
      },
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
          final taskIndex =
              _allTasks.indexWhere((task) => task['id'] == taskId);
          if (taskIndex != -1) {
            _allTasks[taskIndex]['dueDate'] =
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
            _allTasks[taskIndex]['status'] = 'pending';
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task rescheduled successfully'),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _handleActionButtonPressed(String taskId) {
    final task = _allTasks.firstWhere((t) => t['id'] == taskId);
    final actionLabel = (task['actionLabel'] ?? '') as String;

    if (actionLabel == 'Book Transport') {
      // Show logistics agent popup with Indian agency names
      showDialog(
        context: context,
        builder: (context) {
          final List<Map<String, dynamic>> agencies = [
            {"name": "Sharma Logistics", "cost": 1000},
            {"name": "Patel Transport Co.", "cost": 1330},
            {"name": "Singh Cargo Movers", "cost": 1660},
            {"name": "Deshmukh Freightways", "cost": 2000},
          ];
          return AlertDialog(
            title: Text('Logictics agent',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    'Found four options to the market with the best price',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
                ...agencies.map((agency) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          agency['name'],
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        '\u20B9${agency['cost']}',
                        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Booked with ${agency['name']} for \u20B9${agency['cost']}'),
                              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text('Book'),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          );
        },
      );
    } else {
      // Simulate IoT device response
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$actionLabel command sent successfully'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: 'View Status',
            textColor: AppTheme.lightTheme.colorScheme.onPrimary,
            onPressed: () {
              // Navigate to device control panel
              Navigator.pushNamed(context, '/device-control-panel');
            },
          ),
        ),
      );
    }
  }

  void _handleTaskAdded(Map<String, dynamic> newTask) {
    setState(() {
      _allTasks.insert(0, newTask);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task added successfully!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    _refreshController.forward();

    // Simulate API call to refresh tasks
    await Future.delayed(Duration(milliseconds: 1500));

    // Update task statuses and IoT device availability
    setState(() {
      // Simulate some status updates
      for (var task in _allTasks) {
        if (task['status'] == 'pending') {
          final taskDateParts = (task['dueDate'] as String).split('/');
          final taskDate = DateTime(
            int.parse(taskDateParts[2]),
            int.parse(taskDateParts[1]),
            int.parse(taskDateParts[0]),
          );

          if (taskDate.isBefore(DateTime.now())) {
            task['status'] = 'overdue';
          }
        }
      }
    });

    _refreshController.reverse();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tasks refreshed successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showAddTaskModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTaskModal(
        onTaskAdded: _handleTaskAdded,
      ),
    );
  }

  void _handleBottomNavigation(int index) {
    final routes = [
      '/farm-dashboard',
      '/io-t-hub',
      '/task-management',
      '/weather-details',
      '/device-control-panel',
    ];

    if (index != 2) {
      // Don't navigate if already on task management
      Navigator.pushReplacementNamed(context, routes[index]);
    }
  }

  void _handleBulkActions() {
    if (_selectedTaskIds.isEmpty) return;

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
              Text(
                'Bulk Actions (${_selectedTaskIds.length} selected)',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
                title: Text('Mark as Complete'),
                onTap: () {
                  setState(() {
                    for (String taskId in _selectedTaskIds) {
                      final taskIndex =
                          _allTasks.indexWhere((task) => task['id'] == taskId);
                      if (taskIndex != -1) {
                        _allTasks[taskIndex]['status'] = 'completed';
                      }
                    }
                    _selectedTaskIds.clear();
                    _isSelectionMode = false;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 6.w,
                ),
                title: Text('Delete Selected'),
                onTap: () {
                  setState(() {
                    _allTasks.removeWhere(
                        (task) => _selectedTaskIds.contains(task['id']));
                    _selectedTaskIds.clear();
                    _isSelectionMode = false;
                  });
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filteredTasks;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Task Management',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        elevation: 0,
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              onPressed: _handleBulkActions,
              icon: CustomIconWidget(
                iconName: 'more_vert',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 6.w,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _isSelectionMode = false;
                  _selectedTaskIds.clear();
                });
              },
              icon: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 6.w,
              ),
            ),
          ] else ...[
            IconButton(
              onPressed: _showAddTaskModal,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 6.w,
              ),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            color: AppTheme.lightTheme.colorScheme.primary,
            child: Column(
              children: [
                TaskFilterChips(
                  selectedFilter: _selectedFilter,
                  onFilterChanged: _handleFilterChanged,
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),

          // Task count and status
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              children: [
                Text(
                  '${filteredTasks.length} tasks',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                if (_isSelectionMode)
                  Text(
                    '${_selectedTaskIds.length} selected',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),

          // Task list
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'task_alt',
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.3),
                          size: 20.w,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'No tasks found',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Add a new task to get started',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _handleRefresh,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: AnimatedBuilder(
                      animation: _refreshAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _refreshAnimation.value * 2 * 3.14159,
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: filteredTasks.length,
                            itemBuilder: (context, index) {
                              final task = filteredTasks[index];
                              return TaskCard(
                                task: task,
                                onTaskComplete: _handleTaskComplete,
                                onTaskEdit: _handleTaskEdit,
                                onTaskDelete: _handleTaskDelete,
                                onTaskReschedule: _handleTaskReschedule,
                                onActionButtonPressed:
                                    _handleActionButtonPressed,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: _isSelectionMode
          ? null
          : FloatingActionButton(
              onPressed: _showAddTaskModal,
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
              child: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onTertiary,
                size: 7.w,
              ),
            ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: 2,
        onTap: _handleBottomNavigation,
      ),
    );
  }
}
