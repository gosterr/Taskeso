import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../themes/app_theme.dart';
import '../utils/app_utils.dart';
import '../widgets/task_form.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editTask(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteTask(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTaskHeader(context),
              const SizedBox(height: 24),
              _buildTaskDescription(),
              const SizedBox(height: 24),
              _buildTaskMetadata(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Provider.of<TaskProvider>(context, listen: false)
              .toggleTaskCompletion(task.id);
          Navigator.pop(context);
        },
        icon: Icon(
          task.isCompleted ? Icons.refresh : Icons.check,
        ),
        label: Text(
          task.isCompleted ? 'Mark as Pending' : 'Mark as Completed',
        ),
      ),
    );
  }

  Widget _buildTaskHeader(BuildContext context) {
    final isOverdue = AppUtils.isOverdue(task.dueDate) && !task.isCompleted;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: task.isCompleted
              ? Colors.grey.withOpacity(0.3)
              : AppTheme.getPriorityColor(task.priority).withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildPriorityBadge(),
              const SizedBox(width: 8),
              _buildCategoryBadge(),
              if (isOverdue) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppTheme.errorColor,
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 12,
                        color: AppTheme.errorColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'OVERDUE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.errorColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: task.isCompleted
                      ? AppTheme.successColor.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: task.isCompleted
                        ? AppTheme.successColor
                        : Colors.grey,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  task.isCompleted ? 'Completed' : 'Pending',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: task.isCompleted
                        ? AppTheme.successColor
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            task.title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: task.isCompleted
                  ? Colors.grey
                  : AppTheme.textPrimaryColor,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          const SizedBox(height: 16),
          if (task.dueDate != null) ...[
            Row(
              children: [
                Icon(
                  Icons.event,
                  size: 16,
                  color: isOverdue
                      ? AppTheme.errorColor
                      : task.isCompleted
                          ? Colors.grey
                          : AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Due: ${AppUtils.formatDate(task.dueDate)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isOverdue
                        ? AppTheme.errorColor
                        : task.isCompleted
                            ? Colors.grey
                            : AppTheme.textSecondaryColor,
                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriorityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.getPriorityColor(task.priority).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppTheme.getPriorityColor(task.priority),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getPriorityIcon(),
            size: 12,
            color: AppTheme.getPriorityColor(task.priority),
          ),
          const SizedBox(width: 4),
          Text(
            AppUtils.formatPriority(task.priority),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppTheme.getPriorityColor(task.priority),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPriorityIcon() {
    switch (task.priority) {
      case 0:
        return FontAwesomeIcons.arrowDown;
      case 1:
        return FontAwesomeIcons.minus;
      case 2:
        return FontAwesomeIcons.arrowUp;
      default:
        return FontAwesomeIcons.minus;
    }
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.getCategoryColor(task.category).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppTheme.getCategoryColor(task.category),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getCategoryIcon(),
            size: 12,
            color: AppTheme.getCategoryColor(task.category),
          ),
          const SizedBox(width: 4),
          Text(
            task.category,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppTheme.getCategoryColor(task.category),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon() {
    switch (task.category) {
      case 'Personal':
        return FontAwesomeIcons.user;
      case 'Work':
        return FontAwesomeIcons.briefcase;
      case 'Shopping':
        return FontAwesomeIcons.cartShopping;
      case 'Health':
        return FontAwesomeIcons.heartPulse;
      case 'Financial':
        return FontAwesomeIcons.moneyBill;
      case 'Education':
        return FontAwesomeIcons.graduationCap;
      default:
        return FontAwesomeIcons.listCheck;
    }
  }

  Widget _buildTaskDescription() {
    if (task.description == null || task.description!.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.description,
                  size: 18,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'No description provided',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description,
                size: 18,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            task.description!,
            style: TextStyle(
              fontSize: 14,
              color: task.isCompleted
                  ? Colors.grey
                  : AppTheme.textSecondaryColor,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskMetadata() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                size: 18,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Additional Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: 'Created on',
            value: AppUtils.formatDate(task.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => TaskForm(task: task, isEditing: true),
    );
  }

  Future<void> _deleteTask(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await Provider.of<TaskProvider>(context, listen: false)
          .deleteTask(task.id);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task deleted'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
} 