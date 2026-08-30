class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final DateTime birthDate;
  final double? weightKg;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.birthDate,
    this.weightKg,
  });

  String get fullName => '$firstName $lastName';

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      birthDate: DateTime.parse(json['birth_date']),
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
    );
  }
}