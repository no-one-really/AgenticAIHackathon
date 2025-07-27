import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AddTaskModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onTaskAdded;

  const AddTaskModal({
    Key? key,
    required this.onTaskAdded,
  }) : super(key: key);

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedPriority = 'medium';
  String _selectedTemplate = 'custom';
  DateTime _selectedDate = DateTime.now().add(Duration(days: 1));
  bool _hasAction = false;
  String _actionLabel = '';
  String _actionIcon = 'play_arrow';

  final List<Map<String, dynamic>> _templates = [
    {
      'id': 'custom',
      'title': 'Custom Task',
      'description': 'Create a custom agricultural task',
      'icon': 'add_task',
      'hasAction': false,
    },
    {
      'id': 'spray_pesticide',
      'title': 'Spray Pesticide',
      'description': 'Apply pesticide treatment to crops',
      'icon': 'pest_control',
      'hasAction': true,
      'actionLabel': 'Trigger Drones',
      'actionIcon': 'flight',
    },
    {
      'id': 'water_crops',
      'title': 'Water Crops',
      'description': 'Irrigate designated crop areas',
      'icon': 'water_drop',
      'hasAction': true,
      'actionLabel': 'Turn on Actuator',
      'actionIcon': 'power',
    },
    {
      'id': 'soil_testing',
      'title': 'Soil Testing',
      'description': 'Collect and analyze soil samples',
      'icon': 'science',
      'hasAction': false,
    },
    {
      'id': 'harvest',
      'title': 'Harvest Crops',
      'description': 'Harvest mature crops from designated areas',
      'icon': 'agriculture',
      'hasAction': false,
    },
    {
      'id': 'fertilize',
      'title': 'Apply Fertilizer',
      'description': 'Apply fertilizer to enhance crop growth',
      'icon': 'eco',
      'hasAction': true,
      'actionLabel': 'Activate Spreader',
      'actionIcon': 'scatter_plot',
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _selectTemplate(String templateId) {
    final template = _templates.firstWhere((t) => t['id'] == templateId);
    setState(() {
      _selectedTemplate = templateId;
      if (templateId != 'custom') {
        _titleController.text = template['title'];
        _descriptionController.text = template['description'];
        _hasAction = template['hasAction'] ?? false;
        _actionLabel = template['actionLabel'] ?? '';
        _actionIcon = template['actionIcon'] ?? 'play_arrow';
      } else {
        _titleController.clear();
        _descriptionController.clear();
        _hasAction = false;
        _actionLabel = '';
        _actionIcon = 'play_arrow';
      }
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              headerBackgroundColor: AppTheme.lightTheme.colorScheme.primary,
              headerForegroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.lightTheme.colorScheme.onPrimary;
                }
                return AppTheme.lightTheme.colorScheme.onSurface;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.lightTheme.colorScheme.primary;
                }
                return Colors.transparent;
              }),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'priority': _selectedPriority,
        'dueDate':
            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
        'status': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
        if (_hasAction) ...{
          'actionLabel': _actionLabel,
          'actionIcon': _actionIcon,
        },
      };

      widget.onTaskAdded(newTask);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Add New Task',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Templates section
                    Text(
                      'Task Templates',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      height: 12.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _templates.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 3.w),
                        itemBuilder: (context, index) {
                          final template = _templates[index];
                          final isSelected =
                              _selectedTemplate == template['id'];

                          return GestureDetector(
                            onTap: () => _selectTemplate(template['id']),
                            child: Container(
                              width: 25.w,
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                        .withValues(alpha: 0.1)
                                    : AppTheme.lightTheme.colorScheme.surface,
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme.lightTheme.colorScheme.outline,
                                  width: isSelected ? 2.0 : 1.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIconWidget(
                                    iconName: template['icon'],
                                    color: isSelected
                                        ? AppTheme
                                            .lightTheme.colorScheme.primary
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                    size: 6.w,
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    template['title'],
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: isSelected
                                          ? AppTheme
                                              .lightTheme.colorScheme.primary
                                          : AppTheme
                                              .lightTheme.colorScheme.onSurface,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Task details
                    Text(
                      'Task Details',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Title field
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Task Title',
                        hintText: 'Enter task title',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'title',
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            size: 5.w,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a task title';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Description field
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description (Optional)',
                        hintText: 'Enter task description',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'description',
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            size: 5.w,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Priority and Date row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Priority',
                                style:
                                    AppTheme.lightTheme.textTheme.labelMedium,
                              ),
                              SizedBox(height: 1.h),
                              DropdownButtonFormField<String>(
                                value: _selectedPriority,
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(3.w),
                                    child: CustomIconWidget(
                                      iconName: 'flag',
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                      size: 5.w,
                                    ),
                                  ),
                                ),
                                items: [
                                  DropdownMenuItem(
                                      value: 'low', child: Text('Low')),
                                  DropdownMenuItem(
                                      value: 'medium', child: Text('Medium')),
                                  DropdownMenuItem(
                                      value: 'high', child: Text('High')),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPriority = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Due Date',
                                style:
                                    AppTheme.lightTheme.textTheme.labelMedium,
                              ),
                              SizedBox(height: 1.h),
                              GestureDetector(
                                onTap: _selectDate,
                                child: Container(
                                  padding: EdgeInsets.all(4.w),
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.surface,
                                    border: Border.all(
                                      color: AppTheme
                                          .lightTheme.colorScheme.outline,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Row(
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'calendar_today',
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                        size: 5.w,
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4.h),

                    // Action button toggle
                    if (_selectedTemplate != 'custom') ...[
                      Row(
                        children: [
                          Switch(
                            value: _hasAction,
                            onChanged: (value) {
                              setState(() {
                                _hasAction = value;
                              });
                            },
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              'Include IoT Action Button',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                    ],

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),

          // Submit button
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _submitTask,
                    child: Text('Add Task'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
