import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../cache/insigths_cache.dart';
import '../../models/insights.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({
    super.key,
  });

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  final InsightsCache cache = InsightsCache.instance;

  @override
  void initState() {
    super.initState();
    cache.load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: cache,
      builder: (context, _) {
        if (cache.isLoading && !cache.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (cache.error != null && !cache.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Insights'),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Failed to load insights',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => cache.refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Insights'),
          ),
          body: RefreshIndicator(
            onRefresh: cache.refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                Text(
                  'Your Progress',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                _buildStats(),

                const SizedBox(height: 24),

                _buildVolumeChart(),

                const SizedBox(height: 24),

                _buildExerciseProgress(),

                const SizedBox(height: 24),

                _buildPersonalRecords(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStats() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 132,
      ),
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return _StatCard(
              icon: Icons.fitness_center,
              title: 'Workouts',
              value: cache.workoutsCount.toString(),
              subtitle: 'Last 30 days',
            );

          case 1:
            return _StatCard(
              icon: Icons.trending_up,
              title: 'Volume',
              value: formatVolume(cache.totalVolume),
              subtitle: 'Last 30 days',
            );

          case 2:
            return _StatCard(
              icon: Icons.bar_chart,
              title: 'Avg. Volume',
              value: formatVolume(cache.averageVolume),
              subtitle: 'Per workout',
            );

          case 3:
            return _StatCard(
              icon: Icons.emoji_events,
              title: 'Personal Records',
              value: cache.personalRecords.length.toString(),
              subtitle: 'Exercises',
            );

          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildVolumeChart() {
    if (cache.volumeHistory.isEmpty) {
      return const _EmptyCard(
        title: 'Training Volume',
        message: 'No workouts in the last 30 days.',
      );
    }

    final spots = <FlSpot>[];

    for (int i = 0; i < cache.volumeHistory.length; i++) {
      spots.add(
        FlSpot(
          i.toDouble(),
          cache.volumeHistory[i].volume,
        ),
      );
    }

    final maxVolume = cache.volumeHistory
        .map((e) => e.volume)
        .reduce((a, b) => a > b ? a : b);

    final maxY = maxVolume <= 0 ? 100.0 : maxVolume * 1.2;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Training Volume',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Last 30 days',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxY,
                  minX: 0,
                  maxX: (spots.length - 1).toDouble(),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) {
                            return const Text('0');
                          }

                          return Text(
                            formatVolume(value),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: spots.length <= 5
                            ? 1
                            : (spots.length / 4).ceilToDouble(),
                        getTitlesWidget: (value, meta) {
                          final index = value.round();

                          if (index < 0 ||
                              index >= cache.volumeHistory.length) {
                            return const SizedBox.shrink();
                          }

                          final date = cache.volumeHistory[index].date;

                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '${date.day}/${date.month}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final index = spot.x.round();

                          if (index < 0 ||
                              index >= cache.volumeHistory.length) {
                            return null;
                          }

                          final workout = cache.volumeHistory[index];

                          return LineTooltipItem(
                            '${workout.workoutName}\n'
                            '${formatVolume(workout.volume)}',
                            const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: spots.length <= 15,
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseProgress() {
    final selectedExercise = cache.selectedExercise;

    if (cache.exercises.isEmpty) {
      return const _EmptyCard(
        title: 'Exercise Progress',
        message: 'Complete a workout to start tracking progress.',
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exercise Progress',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _showExerciseSelector,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedExercise?.name ?? 'Select exercise',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (cache.exerciseProgressLoading)
              const SizedBox(
                height: 220,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (cache.exerciseProgress.isEmpty)
              const SizedBox(
                height: 180,
                child: Center(
                  child: Text(
                    'No progress data available.',
                  ),
                ),
              )
            else
              _buildExerciseChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseChart() {
    final progress = cache.exerciseProgress;

    final spots = <FlSpot>[];

    for (int i = 0; i < progress.length; i++) {
      spots.add(
        FlSpot(
          i.toDouble(),
          progress[i].maxWeight,
        ),
      );
    }

    final maxWeight = progress
        .map((e) => e.maxWeight)
        .reduce((a, b) => a > b ? a : b);

    final minWeight = progress
        .map((e) => e.maxWeight)
        .reduce((a, b) => a < b ? a : b);

    final maxY = maxWeight <= 0 ? 100.0 : maxWeight * 1.2;
    final minY = minWeight > 0 ? (minWeight * 0.8).floorToDouble() : 0.0;

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          minX: 0,
          maxX: (spots.length - 1).toDouble(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
          ),
          borderData: FlBorderData(
            show: false,
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toStringAsFixed(0)}kg',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: progress.length <= 5
                    ? 1
                    : (progress.length / 4).ceilToDouble(),
                getTitlesWidget: (value, meta) {
                  final index = value.round();

                  if (index < 0 || index >= progress.length) {
                    return const SizedBox.shrink();
                  }

                  final date = progress[index].date;

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${date.day}/${date.month}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '${spot.y.toStringAsFixed(1)} kg',
                    const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              barWidth: 3,
              dotData: const FlDotData(
                show: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showExerciseSelector() async {
    final selected = await showModalBottomSheet<InsightExercise>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        String searchQuery = '';
        String? selectedCategory;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredExercises = cache.exercises.where((exercise) {
              final matchesSearch = exercise.name
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());

              final matchesCategory = selectedCategory == null ||
                  exercise.primaryMuscle == selectedCategory;

              return matchesSearch && matchesCategory;
            }).toList();

            final categories = cache.exercises
                .map((e) => e.primaryMuscle)
                .whereType<String>()
                .where((e) => e.isNotEmpty)
                .toSet()
                .toList()
              ..sort();

            return SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.82,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search exercise...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          setModalState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),

                    if (categories.isNotEmpty)
                      SizedBox(
                        height: 42,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            ChoiceChip(
                              label: const Text('All'),
                              selected: selectedCategory == null,
                              onSelected: (_) {
                                setModalState(() {
                                  selectedCategory = null;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            ...categories.map(
                              (category) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(category),
                                  selected: selectedCategory == category,
                                  onSelected: (_) {
                                    setModalState(() {
                                      selectedCategory = category;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 8),

                    Expanded(
                      child: filteredExercises.isEmpty
                          ? const Center(
                              child: Text('No exercises found.'),
                            )
                          : ListView.builder(
                              itemCount: filteredExercises.length,
                              itemBuilder: (context, index) {
                                final exercise = filteredExercises[index];
                                final isSelected =
                                    cache.selectedExercise?.id == exercise.id;

                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Icon(
                                      isSelected
                                          ? Icons.check
                                          : Icons.fitness_center,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(exercise.name),
                                  subtitle: exercise.primaryMuscle != null
                                      ? Text(exercise.primaryMuscle!)
                                      : null,
                                  trailing: isSelected
                                      ? const Icon(Icons.check)
                                      : null,
                                  onTap: () {
                                    Navigator.pop(context, exercise);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (selected != null) {
      await cache.selectExercise(selected);
    }
  }

  Widget _buildPersonalRecords() {
    if (cache.personalRecords.isEmpty) {
      return const _EmptyCard(
        title: 'Personal Records',
        message: 'Complete some exercises to start setting records.',
      );
    }

    final records = cache.personalRecords.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Records',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...records.map(
              (record) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_events_outlined,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        record.exerciseName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${record.maxWeight.toStringAsFixed(1)} kg',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 24,
            ),
            const Spacer(),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String title;
  final String message;

  const _EmptyCard({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 24),
            Icon(
              Icons.bar_chart,
              size: 42,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

String formatVolume(double volume) {
  if (volume >= 1000000) {
    return '${(volume / 1000000).toStringAsFixed(1)}M';
  }

  if (volume >= 1000) {
    return '${(volume / 1000).toStringAsFixed(1)}k';
  }

  return volume.toStringAsFixed(0);
}