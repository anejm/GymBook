class Exercise {
  final String id;
  final String name;
  final String primaryMuscle;

  Exercise({
    required this.id,
    required this.name,
    required this.primaryMuscle,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      primaryMuscle: json['primary_muscle'] ?? '',
    );
  }
}

