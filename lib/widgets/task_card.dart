import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../themes/app_theme.dart';
import '../utils/app_utils.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOverdue = AppUtils.isOverdue(task.dueDate) && !task.isCompleted;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Slidable(
        key: ValueKey(task.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(
            onDismissed: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(task.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task deleted'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          children: [
            SlidableAction(
              onPressed: (_) {
                Provider.of<TaskProvider>(context, listen: false)
                    .toggleTaskCompletion(task.id);
              },
              backgroundColor: AppTheme.successColor,
              foregroundColor: Colors.white,
              icon: task.isCompleted
                  ? FontAwesomeIcons.hourglass
                  : FontAwesomeIcons.check,
              label: task.isCompleted ? 'Unmark' : 'Complete',
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            SlidableAction(
              onPressed: (_) {
                Provider.of<TaskProvider>(context, listen: false)
                    .deleteTask(task.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Task deleted'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
              icon: FontAwesomeIcons.trash,
              label: 'Delete',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildCategoryBadge(),
                      const SizedBox(width: 8),
                      _buildPriorityBadge(),
                      const Spacer(),
                      _buildCompletionCheckbox(context),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTaskTitle(),
                  if (task.description != null && task.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildTaskDescription(),
                  ],
                  const SizedBox(height: 12),
                  _buildDueDate(isOverdue),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.getCategoryColor(task.category).withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppTheme.getCategoryColor(task.category),
          width: 0.5,
        ),
      ),
      child: Text(
        task.category,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppTheme.getCategoryColor(task.category),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.getPriorityColor(task.priority).withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppTheme.getPriorityColor(task.priority),
          width: 0.5,
        ),
      ),
      child: Text(
        AppUtils.formatPriority(task.priority),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppTheme.getPriorityColor(task.priority),
        ),
      ),
    );
  }

  Widget _buildCompletionCheckbox(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<TaskProvider>(context, listen: false)
            .toggleTaskCompletion(task.id);
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: task.isCompleted
              ? AppTheme.primaryColor
              : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: task.isCompleted
                ? AppTheme.primaryColor
                : Colors.grey.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: task.isCompleted
            ? const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              )
            : null,
      ),
    );
  }

  Widget _buildTaskTitle() {
    return Text(
      task.title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: task.isCompleted
            ? Colors.grey
            : AppTheme.textPrimaryColor,
        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
      ),
    );
  }

  Widget _buildTaskDescription() {
    return Text(
      task.description!,
      style: TextStyle(
        fontSize: 14,
        color: task.isCompleted
            ? Colors.grey
            : AppTheme.textSecondaryColor,
        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDueDate(bool isOverdue) {
    if (task.dueDate == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Icon(
          Icons.schedule,
          size: 14,
          color: isOverdue
              ? AppTheme.errorColor
              : task.isCompleted
                  ? Colors.grey
                  : AppTheme.textSecondaryColor,
        ),
        const SizedBox(width: 4),
        Text(
          AppUtils.formatDate(task.dueDate),
          style: TextStyle(
            fontSize: 12,
            color: isOverdue
                ? AppTheme.errorColor
                : task.isCompleted
                    ? Colors.grey
                    : AppTheme.textSecondaryColor,
            fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (isOverdue) ...[
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.errorColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'OVERDUE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppTheme.errorColor,
              ),
            ),
          ),
        ],
      ],
    );
  }
} 