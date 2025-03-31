import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../themes/app_theme.dart';
import '../utils/app_utils.dart';

class TaskForm extends StatefulWidget {
  final Task? task;
  final bool isEditing;

  const TaskForm({
    Key? key,
    this.task,
    this.isEditing = false,
  }) : super(key: key);

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  String _category = 'Personal';
  int _priority = 1;
  
  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _dueDate = widget.task!.dueDate != null 
          ? DateTime(
              widget.task!.dueDate!.year,
              widget.task!.dueDate!.month,
              widget.task!.dueDate!.day,
            )
          : null;
      _dueTime = widget.task!.dueDate != null
          ? TimeOfDay(
              hour: widget.task!.dueDate!.hour,
              minute: widget.task!.dueDate!.minute,
            )
          : null;
      _category = widget.task!.category;
      _priority = widget.task!.priority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.isEditing ? 'Edit Task' : 'Add New Task',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildTitleField(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 16),
              _buildDueDateField(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildCategoryDropdown()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildPrioritySelector()),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _saveTask,
                icon: FaIcon(
                  widget.isEditing 
                      ? FontAwesomeIcons.penToSquare 
                      : FontAwesomeIcons.plus,
                  size: 16,
                ),
                label: Text(widget.isEditing ? 'Update Task' : 'Add Task'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Title',
        prefixIcon: Icon(Icons.title),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description (optional)',
        prefixIcon: Icon(Icons.description),
        alignLabelWithHint: true,
      ),
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildDueDateField() {
    String dueDateText = 'No due date';
    
    if (_dueDate != null) {
      dueDateText = DateFormat('EEE, MMM d, yyyy').format(_dueDate!);
      if (_dueTime != null) {
        dueDateText += ' at ${_dueTime!.format(context)}';
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Due Date & Time',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.event,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        dueDateText,
                        style: TextStyle(
                          color: _dueDate == null
                              ? Colors.grey
                              : AppTheme.textPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildDateTimeButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildDateTimeButton() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: _selectDateTime,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            minimumSize: const Size(50, 50),
          ),
          child: const Icon(Icons.schedule),
        ),
        if (_dueDate != null) ...[
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _dueDate = null;
                _dueTime = null;
              });
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              minimumSize: const Size(50, 50),
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Icon(Icons.clear),
          ),
        ],
      ],
    );
  }

  Future<void> _selectDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppTheme.textPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: _dueTime ?? TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppTheme.primaryColor,
                onPrimary: Colors.white,
                onSurface: AppTheme.textPrimaryColor,
              ),
            ),
            child: child!,
          );
        },
      );

      setState(() {
        _dueDate = pickedDate;
        _dueTime = pickedTime ?? TimeOfDay.now();
      });
    }
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
          child: DropdownButton<String>(
            value: _category,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            icon: const Icon(Icons.arrow_drop_down),
            items: AppUtils.getDefaultCategories()
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppTheme.getCategoryColor(value),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(value),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _category = newValue;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPriorityButton(0, 'Low'),
              _buildPriorityButton(1, 'Medium'),
              _buildPriorityButton(2, 'High'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityButton(int priority, String label) {
    final selected = _priority == priority;
    final color = AppTheme.getPriorityColor(priority);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _priority = priority;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: selected
              ? Border.all(color: color, width: 1)
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? color : AppTheme.textSecondaryColor,
          ),
        ),
      ),
    );
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      // Combine date and time if both are set
      DateTime? combinedDateTime;
      if (_dueDate != null) {
        if (_dueTime != null) {
          combinedDateTime = DateTime(
            _dueDate!.year,
            _dueDate!.month,
            _dueDate!.day,
            _dueTime!.hour,
            _dueTime!.minute,
          );
        } else {
          combinedDateTime = _dueDate;
        }
      }

      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      
      if (widget.isEditing && widget.task != null) {
        final updatedTask = widget.task!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          dueDate: combinedDateTime,
          category: _category,
          priority: _priority,
        );
        
        await taskProvider.updateTask(updatedTask);
        if (mounted) {
          AppUtils.showSnackBar(context, 'Task updated successfully');
          Navigator.pop(context);
        }
      } else {
        final newTask = Task(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          dueDate: combinedDateTime,
          category: _category,
          priority: _priority,
        );
        
        await taskProvider.addTask(newTask);
        if (mounted) {
          AppUtils.showSnackBar(context, 'Task added successfully');
          Navigator.pop(context);
        }
      }
    }
  }
} 