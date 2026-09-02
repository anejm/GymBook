class VolumeData {

  final DateTime date;
  final double volume;
  final String workoutName;

  VolumeData({
    required this.date,
    required this.volume,
    required this.workoutName,
  });
}


class InsightExercise {

  final String id;
  final String name;
  final String? primaryMuscle;

  InsightExercise({
    required this.id,
    required this.name,
    this.primaryMuscle,
  });
}


class ExerciseProgress {

  final DateTime date;
  final double maxWeight;

  ExerciseProgress({
    required this.date,
    required this.maxWeight,
  });
}


class PersonalRecord {

  final String exerciseName;
  final double maxWeight;

  PersonalRecord({
    required this.exerciseName,
    required this.maxWeight,
  });
}
