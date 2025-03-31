import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../screens/task_detail_screen.dart';
import '../themes/app_theme.dart';
import '../widgets/task_card.dart';
import '../widgets/task_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    // Initialize TaskProvider when Home screen is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            _buildCategoryFilter(),
            const SizedBox(height: 16),
            _buildTaskFilters(),
            const SizedBox(height: 16),
            _buildTasksList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.listCheck,
                        color: Colors.white.withOpacity(0.9),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Taskeso',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Get things done!',
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    repeatForever: false,
                    totalRepeatCount: 1,
                  ),
                ],
              ),
              Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  final statistics = taskProvider.getTaskStatistics();
                  final completedPercentage = statistics['total'] != 0
                      ? (statistics['completed']! / statistics['total']! * 100).round()
                      : 0;
                  
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: CircularProgressIndicator(
                            value: statistics['total'] != 0
                                ? statistics['completed']! / statistics['total']!
                                : 0,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.accentColor,
                            ),
                            strokeWidth: 6,
                          ),
                        ),
                        Text(
                          '$completedPercentage%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              final statistics = taskProvider.getTaskStatistics();
              
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    iconData: FontAwesomeIcons.listCheck,
                    count: statistics['total'] ?? 0,
                    label: 'Total',
                  ),
                  _buildStatItem(
                    iconData: FontAwesomeIcons.check,
                    count: statistics['completed'] ?? 0,
                    label: 'Done',
                    color: AppTheme.successColor,
                  ),
                  _buildStatItem(
                    iconData: FontAwesomeIcons.hourglass,
                    count: statistics['pending'] ?? 0,
                    label: 'Pending',
                    color: AppTheme.accentColor,
                  ),
                  _buildStatItem(
                    iconData: FontAwesomeIcons.circleExclamation,
                    count: statistics['overdue'] ?? 0,
                    label: 'Overdue',
                    color: AppTheme.errorColor,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData iconData,
    required int count,
    required String label,
    Color? color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (color ?? Colors.white).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            iconData,
            color: color ?? Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final categories = taskProvider.getAllCategories();
        
        return SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = _selectedCategory == category;
              
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                    taskProvider.setCategoryFilter(category);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? category == 'All'
                              ? AppTheme.primaryColor
                              : AppTheme.getCategoryColor(category)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        if (category != 'All') ...[
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.getCategoryColor(category),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          category,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : category == 'All'
                                    ? AppTheme.primaryColor
                                    : AppTheme.getCategoryColor(category),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTaskFilters() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final filter = taskProvider.filter;
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildFilterButton(
                  label: 'All',
                  isSelected: filter == 'All',
                  onTap: () => taskProvider.setFilter('All'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterButton(
                  label: 'Pending',
                  isSelected: filter == 'Pending',
                  onTap: () => taskProvider.setFilter('Pending'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterButton(
                  label: 'Completed',
                  isSelected: filter == 'Completed',
                  onTap: () => taskProvider.setFilter('Completed'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTasksList() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks = taskProvider.tasks;
        
        if (tasks.isEmpty) {
          return Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FontAwesomeIcons.clipboardList,
                    size: 60,
                    color: Colors.grey.withOpacity(0.7),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(
                        duration: 600.ms,
                        curve: Curves.easeOutBack,
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1, 1),
                      ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 300.ms)
                      .moveY(
                        duration: 600.ms,
                        begin: 20,
                        curve: Curves.easeOutQuad,
                      ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add a new task',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 600.ms)
                      .moveY(
                        duration: 600.ms,
                        begin: 20,
                        curve: Curves.easeOutQuad,
                      ),
                ],
              ),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskCard(
                task: task,
                onTap: () => _navigateToTaskDetail(context, task),
              )
                  .animate()
                  .fadeIn(
                    duration: 300.ms,
                    delay: Duration(milliseconds: index * 50),
                  )
                  .moveX(
                    begin: 30,
                    curve: Curves.easeOutQuad,
                    duration: 300.ms,
                    delay: Duration(milliseconds: index * 50),
                  );
            },
          ),
        );
      },
    );
  }

  void _navigateToTaskDetail(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(task: task),
      ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const TaskForm(),
    );
  }
} 