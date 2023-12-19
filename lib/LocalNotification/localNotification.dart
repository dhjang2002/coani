// ignore_for_file: non_constant_identifier_names, file_names
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotification {
  final AndroidIcon = "ic_notification";
  final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  int push_index;
  LocalNotification({
    this.push_index = 0
  });

  Future <void> init() async {
    await configureLocalTimeZone();
    await initializeNotification();
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future <void> initializeNotification() async {
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_notification');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> cancel() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> requestPermissions() async {
    await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation <
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true,);
  }

  Future <void> show(String title, String message) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    NotificationDetails notificationDetails =
    NotificationDetails(
      android: AndroidNotificationDetails(
        "easyapproach",
        "easyapproach channel",
        importance: Importance.max,
        priority: Priority.high,
        // ongoing: true,
        // styleInformation: BigTextStyleInformation(message),
        icon: AndroidIcon,
      ),
      iOS: const DarwinNotificationDetails(
        badgeNumber: 1,
      ),
    );

    await _flutterLocalNotificationsPlugin.show(
      id, title, message, notificationDetails,);
  }

  Future <void> showSchedule({
    required int hour,
    required int minutes,
    required message,
    required String title,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes,);
    await _flutterLocalNotificationsPlugin.zonedSchedule(0,
      title,
      message,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          "easyapproach",
          "easyapproach channel",
          importance: Importance.max,
          priority: Priority.high,
          // ongoing: true,
          // styleInformation: BigTextStyleInformation(message),
          icon: AndroidIcon,
        ),
        iOS: const DarwinNotificationDetails(
          badgeNumber: 1,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}


