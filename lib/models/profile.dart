class UserProfile {
  final String firstName;
  final String lastName;
  final double? weightKg;
  final double? heightCm;
  final DateTime? birthDate;

  UserProfile({
    required this.firstName,
    required this.lastName,
    this.weightKg,
    this.heightCm,
    this.birthDate,
  });

  String get fullName => '$firstName $lastName';

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        weightKg: (json['weight_kg'] as num?)?.toDouble(),
        heightCm: (json['height_cm'] as num?)?.toDouble(),
        birthDate: json['birth_date'] != null
            ? DateTime.parse(json['birth_date'] as String)
            : null,
      );
}