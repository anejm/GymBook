
String formatTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (minutes <= 0) {
      return '$seconds s';
    }

    if (hours <= 0) {
      return '$minutes m : ${seconds.toString().padLeft(2, '0')} s';
    }

    return '$hours h : '
        '${minutes.toString().padLeft(2, '0')} m : '
        '${seconds.toString().padLeft(2, '0')} s';
  }