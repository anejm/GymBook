import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class WorkoutNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const int _notificationId = 1001;
  static const String _channelId = 'active_workout';
  static const String _channelName = 'Active Workout';

  static Timer? _timer;

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings: settings,
    );

    final androidPlugin =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Shows the currently active workout',
      importance: Importance.defaultImportance,
    );

    await androidPlugin?.createNotificationChannel(channel);
  }

  static Future<void> start({
    required String workoutName,
    required DateTime startedAt,
  }) async {
    _timer?.cancel();

    final androidPlugin =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    await androidPlugin.startForegroundService(
      id: _notificationId,
      title: workoutName,
      body: _formatElapsed(startedAt),
      notificationDetails: _androidNotificationDetails(),
    );

    await _update(
      workoutName: workoutName,
      startedAt: startedAt,
    );

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) async {
        await _update(
          workoutName: workoutName,
          startedAt: startedAt,
        );
      },
    );
  }

  static Future<void> _update({
    required String workoutName,
    required DateTime startedAt,
  }) async {
    final androidPlugin =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    await androidPlugin.show(
      id: _notificationId,
      title: workoutName,
      body: _formatElapsed(startedAt),
      notificationDetails: _androidNotificationDetails(),
    );
  }

  static AndroidNotificationDetails _androidNotificationDetails() {
    return const AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Shows the currently active workout',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      ongoing: true,
      playSound: false,
      enableVibration: false,
      autoCancel: false,
      showWhen: false,
      category: AndroidNotificationCategory.service,
      onlyAlertOnce: true,
      visibility: NotificationVisibility.public,
    );
  }

  static String _formatElapsed(DateTime startedAt) {
    final elapsed = DateTime.now().difference(startedAt);

    final hours = elapsed.inHours;
    final minutes = elapsed.inMinutes.remainder(60);
    final seconds = elapsed.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  static Future<void> stop() async {
    _timer?.cancel();
    _timer = null;

    final androidPlugin =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.stopForegroundService();

    await _notifications.cancel(
      id: _notificationId,
    );
  }
}