import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppUtils {
  // Format date to friendly format
  static String formatDate(DateTime? date) {
    if (date == null) return 'No due date';
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);
    
    if (dateToCheck == today) {
      return 'Today, ${DateFormat('h:mm a').format(date)}';
    } else if (dateToCheck == tomorrow) {
      return 'Tomorrow, ${DateFormat('h:mm a').format(date)}';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday, ${DateFormat('h:mm a').format(date)}';
    } else if (date.year == now.year) {
      return DateFormat('MMM d, h:mm a').format(date);
    } else {
      return DateFormat('MMM d, yyyy, h:mm a').format(date);
    }
  }
  
  // Get relative time (e.g., "2 hours ago", "in 3 days")
  static String getRelativeTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    
    final inDays = difference.inDays;
    final inHours = difference.inHours;
    final inMinutes = difference.inMinutes;
    
    if (inDays > 365) {
      final years = (inDays / 365).floor();
      return years == 1 ? 'in 1 year' : 'in $years years';
    } else if (inDays > 30) {
      final months = (inDays / 30).floor();
      return months == 1 ? 'in 1 month' : 'in $months months';
    } else if (inDays > 0) {
      return inDays == 1 ? 'in 1 day' : 'in $inDays days';
    } else if (inHours > 0) {
      return inHours == 1 ? 'in 1 hour' : 'in $inHours hours';
    } else if (inMinutes > 0) {
      return inMinutes == 1 ? 'in 1 minute' : 'in $inMinutes minutes';
    } else if (inMinutes == 0) {
      return 'just now';
    } else if (inMinutes > -60) {
      final mins = inMinutes.abs();
      return mins == 1 ? '1 minute ago' : '$mins minutes ago';
    } else if (inHours > -24) {
      final hours = inHours.abs();
      return hours == 1 ? '1 hour ago' : '$hours hours ago';
    } else if (inDays > -30) {
      final days = inDays.abs();
      return days == 1 ? '1 day ago' : '$days days ago';
    } else if (inDays > -365) {
      final months = (inDays.abs() / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else {
      final years = (inDays.abs() / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    }
  }
  
  // Check if a task is overdue
  static bool isOverdue(DateTime? dueDate) {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate.isBefore(now);
  }
  
  // Show a snackbar
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red : Colors.black87,
        duration: Duration(seconds: isError ? 5 : 3),
      ),
    );
  }
  
  // Format priority text
  static String formatPriority(int priority) {
    switch (priority) {
      case 0:
        return 'Low';
      case 1:
        return 'Medium';
      case 2:
        return 'High';
      default:
        return 'Medium';
    }
  }
  
  // Default categories list
  static List<String> getDefaultCategories() {
    return [
      'Personal',
      'Work',
      'Shopping',
      'Health',
      'Financial',
      'Education',
      'Other',
    ];
  }
} 