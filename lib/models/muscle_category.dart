const Map<String, String> muscleCategories = {
  'chest': 'Chest',
  'shoulders': 'Shoulders',
  'biceps': 'Arms',
  'triceps': 'Arms',
  'forearms': 'Arms',
  'lats': 'Back',
  'middle back': 'Back',
  'lower back': 'Back',
  'traps': 'Back',
  'neck': 'Back',
  'abdominals': 'Core',
  'quadriceps': 'Legs',
  'hamstrings': 'Legs',
  'calves': 'Legs',
  'glutes': 'Legs',
  'adductors': 'Legs',
  'abductors': 'Legs',
};

String categoryOf(String primaryMuscle) =>
    muscleCategories[primaryMuscle] ?? 'Other';

const List<String> exerciseCategories = [
  'All', 'Chest', 'Back', 'Shoulders', 'Arms', 'Core', 'Legs',
];