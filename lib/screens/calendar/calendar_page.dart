import 'package:flutter/material.dart';

import '../../cache/workout_cache.dart';
import '../../models/workout_details.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final WorkoutCache cache = WorkoutCache.instance;

  DateTime _focusedMonth = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    cache.addListener(_onCacheUpdate);
  }

  @override
  void dispose() {
    cache.removeListener(_onCacheUpdate);
    super.dispose();
  }

  void _onCacheUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  List<Workout> _workoutsForDate(DateTime date) {
    return cache.workouts.where((workout) {
      return workout.date.year == date.year &&
          workout.date.month == date.month &&
          workout.date.day == date.day;
    }).toList();
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSelected(DateTime date) {
    return date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + 1,
      );
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCalendar(),
          const SizedBox(height: 20),
          _buildSelectedDay(),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final firstDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    );

    final daysInMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      0,
    ).day;

    // Monday = 1, Sunday = 7
    final startingOffset = firstDayOfMonth.weekday - 1;

    final totalCells = startingOffset + daysInMonth;
    final numberOfRows = (totalCells / 7).ceil();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMonthHeader(),
            const SizedBox(height: 16),
            _buildWeekdayHeader(),
            const SizedBox(height: 8),
            ...List.generate(
              numberOfRows,
              (row) {
                return Row(
                  children: List.generate(
                    7,
                    (column) {
                      final cellIndex = row * 7 + column;
                      final dayNumber = cellIndex - startingOffset + 1;

                      if (dayNumber < 1 || dayNumber > daysInMonth) {
                        return const Expanded(
                          child: SizedBox(height: 52),
                        );
                      }

                      final date = DateTime(
                        _focusedMonth.year,
                        _focusedMonth.month,
                        dayNumber,
                      );

                      return Expanded(
                        child: _buildDay(
                          date,
                          dayNumber,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _previousMonth,
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          '${_monthName(_focusedMonth.month)} ${_focusedMonth.year}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        IconButton(
          onPressed: _nextMonth,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeader() {
    const weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDay(DateTime date, int dayNumber) {
    final isSelected = _isSelected(date);
    final isToday = _isToday(date);
    final workouts = _workoutsForDate(date);
    final hasWorkout = workouts.isNotEmpty;

    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () => _selectDate(date),
      child: SizedBox(
        height: 52,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isSelected)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
              )
            else if (isToday)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor,
                    width: 2,
                  ),
                ),
              ),

            Text(
              '$dayNumber',
              style: TextStyle(
                fontWeight: isToday || isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : null,
              ),
            ),

            if (hasWorkout)
              Positioned(
                bottom: 2,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDay() {
    final workouts = _workoutsForDate(_selectedDate);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatSelectedDate(_selectedDate),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            if (workouts.isEmpty)
              _buildRestDay()
            else
              ...workouts.map(_buildWorkoutTile),
          ],
        ),
      ),
    );
  }

  Widget _buildRestDay() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.event_available_outlined,
        color: Theme.of(context).disabledColor,
      ),
      title: const Text('Rest day'),
      subtitle: Text(
        'No workout recorded',
        style: TextStyle(
          color: Theme.of(context).disabledColor,
        ),
      ),
    );
  }

  Widget _buildWorkoutTile(Workout workout) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        child: const Icon(Icons.fitness_center),
      ),
      title: Text(
        workout.name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${_formatDuration(workout.duration)} • '
        '${workout.exercises.length} '
        '${workout.exercises.length == 1 ? 'exercise' : 'exercises'} • '
        '${workout.totalSets} '
        '${workout.totalSets == 1 ? 'set' : 'sets'}',
      ),
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}min';
    }

    return '${minutes}min';
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  String _formatSelectedDate(DateTime date) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${weekdays[date.weekday - 1]}, '
        '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}