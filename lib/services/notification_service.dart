import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:student_opportunity_hub/reminder_detail_page.dart';
import '../main.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  Function(String reminderId)? onReminderTapped;

  static final FlutterLocalNotificationsPlugin localNotifications =
  FlutterLocalNotificationsPlugin();

  // Android notification plugin
  AndroidFlutterLocalNotificationsPlugin? get _androidPlugin =>
      localNotifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  // ============================================================
  // INITIALIZE
  // ============================================================

  Future<void> initialize() async {
    debugPrint("🔔 Initializing NotificationService...");

    // Initialize timezone database
    tz.initializeTimeZones();

    // ------------------------------------------------------------
    // Android initialization
    // ------------------------------------------------------------

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidSettings,
    );

    await localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint("🔔 Reminder notification tapped");
        debugPrint("Payload: ${response.payload}");

        final reminderId = response.payload;

        if (reminderId == null || reminderId.isEmpty) {
          debugPrint("❌ Reminder ID is empty");
          return;
        }

        debugPrint("🚀 Trying to open ReminderDetailPage...");
        debugPrint("Reminder ID = $reminderId");

        final navigator = navigatorKey.currentState;

        if (navigator == null) {
          debugPrint("❌ navigatorKey.currentState is NULL");
          return;
        }

        debugPrint("✅ Navigator is available");

        navigator.push(
          MaterialPageRoute(
            builder: (context) {
              debugPrint("✅ Building ReminderDetailPage");
              return ReminderDetailPage(
                reminderId: reminderId,
              );
            },
          ),
        );
      },
    );
    debugPrint("✅ Local notifications initialized");

    // ------------------------------------------------------------
    // Android 13+ notification permission
    // ------------------------------------------------------------

    final bool? notificationPermission =
    await _androidPlugin?.requestNotificationsPermission();

    debugPrint(
      "🔔 Notification permission: $notificationPermission",
    );

    // ------------------------------------------------------------
    // Create notification channel
    // ------------------------------------------------------------

    const AndroidNotificationChannel channel =
    AndroidNotificationChannel(
      'reminder_channel',
      'Reminders',
      description: 'Student Opportunity Hub reminder notifications',
      importance: Importance.max,
      playSound: true,
    );

    await _androidPlugin?.createNotificationChannel(channel);

    debugPrint("✅ Reminder notification channel created");

    // ------------------------------------------------------------
    // Exact alarm permission
    // ------------------------------------------------------------

    final bool? exactAlarmPermission =
    await _androidPlugin?.canScheduleExactNotifications();

    debugPrint(
      "⏰ Can schedule exact alarms: $exactAlarmPermission",
    );

    if (exactAlarmPermission != true) {
      debugPrint("⚠️ Exact alarm permission is NOT granted.");

      final bool? requested =
      await _androidPlugin?.requestExactAlarmsPermission();

      debugPrint(
        "⏰ Exact alarm permission request result: $requested",
      );
    } else {
      debugPrint("✅ Exact alarm permission already granted");
    }

    // ------------------------------------------------------------
    // Firebase notification permission
    // ------------------------------------------------------------

    final NotificationSettings settings =
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(
      "🔥 Firebase notification permission: "
          "${settings.authorizationStatus}",
    );

    // ------------------------------------------------------------
    // Get FCM token
    // ------------------------------------------------------------

    final String? token = await _messaging.getToken();

    debugPrint("📱 FCM Token:");
    debugPrint(token);

    // ------------------------------------------------------------
    // Subscribe to allUsers topic
    // ------------------------------------------------------------

    try {
      await _messaging.subscribeToTopic('allUsers');
      debugPrint("✅ Subscribed to allUsers topic successfully");
    } catch (e) {
      debugPrint("❌ Topic subscription error: $e");
    }

    // ------------------------------------------------------------
    // Foreground Firebase notifications
    // ------------------------------------------------------------

    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) {
        debugPrint("📩 Foreground Firebase notification received");

        debugPrint(
          "Title: ${message.notification?.title}",
        );

        debugPrint(
          "Body: ${message.notification?.body}",
        );

        // Show Firebase notification while app is open
        if (message.notification != null) {
          showNotification(
            title: message.notification!.title ?? 'Notification',
            body: message.notification!.body ?? '',
          );
        }
      },
    );

    // ------------------------------------------------------------
    // Firebase notification clicked
    // ------------------------------------------------------------

    FirebaseMessaging.onMessageOpenedApp.listen(
          (RemoteMessage message) {
        debugPrint("👆 Firebase notification clicked");

        debugPrint(
          "Data: ${message.data}",
        );
      },
    );

    debugPrint("✅ NotificationService initialization complete");
  }

  // ============================================================
  // SHOW IMMEDIATE LOCAL NOTIFICATION
  // ============================================================

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    debugPrint("🔔 Showing immediate notification");

    const NotificationDetails notificationDetails =
    NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel',
        'Reminders',
        channelDescription:
        'Student Opportunity Hub reminder notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
    );

    await localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
    );

    debugPrint("✅ Immediate notification shown");
  }

  // ============================================================
  // SCHEDULE REMINDER
  // ============================================================

Future<void> scheduleReminder({
required String title,
required String body,
required String reminderId,
required DateTime dateTime,
})
   async {
    debugPrint("");
    debugPrint("==========================================");
    debugPrint("⏰ SCHEDULING REMINDER");
    debugPrint("==========================================");

    debugPrint("Title: $title");
    debugPrint("Body: $body");
    debugPrint("Requested time: $dateTime");
    debugPrint("Current time: ${DateTime.now()}");

    // ------------------------------------------------------------
    // Check whether selected time is in the past
    // ------------------------------------------------------------

    if (!dateTime.isAfter(DateTime.now())) {
      debugPrint("❌ Selected time is in the past!");
      return;
    }

    // ------------------------------------------------------------
    // Check exact alarm permission AGAIN
    // ------------------------------------------------------------

    bool? canSchedule =
    await _androidPlugin?.canScheduleExactNotifications();

    debugPrint(
      "⏰ Exact alarm permission before scheduling: $canSchedule",
    );

    if (canSchedule != true) {
      debugPrint(
        "⚠️ Exact alarm permission is not granted.",
      );

      debugPrint(
        "📱 Opening exact alarm permission settings...",
      );

      final bool? result =
      await _androidPlugin?.requestExactAlarmsPermission();

      debugPrint(
        "⏰ Permission request result: $result",
      );

      // Check again after request
      canSchedule =
      await _androidPlugin?.canScheduleExactNotifications();

      debugPrint(
        "⏰ Exact alarm permission after request: $canSchedule",
      );

      if (canSchedule != true) {
        debugPrint(
          "❌ EXACT ALARM PERMISSION STILL NOT GRANTED.",
        );

        return;
      }
    }

    debugPrint("✅ Exact alarm permission confirmed");

    // ------------------------------------------------------------
    // Convert DateTime to timezone DateTime
    // ------------------------------------------------------------

    final tz.TZDateTime scheduledDate =
    tz.TZDateTime.from(
      dateTime,
      tz.local,
    );

    debugPrint(
      "📅 Scheduled TZ time: $scheduledDate",
    );

    // ------------------------------------------------------------
    // Unique notification ID
    // ------------------------------------------------------------

    final int notificationId =
        dateTime.millisecondsSinceEpoch ~/ 1000;

    debugPrint(
      "🆔 Notification ID: $notificationId",
    );

    // ------------------------------------------------------------
    // Schedule notification
    // ------------------------------------------------------------

    try {
      await localNotifications.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder_channel',
            'Reminders',
            channelDescription:
            'Student Opportunity Hub reminder notifications',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
          ),
        ),
        payload: reminderId,
        androidScheduleMode:
        AndroidScheduleMode.exactAllowWhileIdle,


      );

      debugPrint("");
      debugPrint("==========================================");
      debugPrint("✅ REMINDER SCHEDULED SUCCESSFULLY");
      debugPrint("==========================================");
    } catch (e) {
      debugPrint("");
      debugPrint("==========================================");
      debugPrint("❌ FAILED TO SCHEDULE REMINDER");
      debugPrint("ERROR: $e");
      debugPrint("==========================================");
    }
  }

  // ============================================================
  // CHECK PENDING NOTIFICATIONS
  // ============================================================

  Future<void> printPendingNotifications() async {
    final List<PendingNotificationRequest> pending =
    await localNotifications.pendingNotificationRequests();

    debugPrint("");
    debugPrint("==========================================");
    debugPrint("📋 PENDING NOTIFICATIONS: ${pending.length}");
    debugPrint("==========================================");

    for (final notification in pending) {
      debugPrint(
        "ID: ${notification.id}",
      );

      debugPrint(
        "Title: ${notification.title}",
      );

      debugPrint(
        "Body: ${notification.body}",
      );
    }
  }

  // ============================================================
  // CANCEL ONE REMINDER
  // ============================================================

  Future<void> cancelReminder(int id) async {
    await localNotifications.cancel(id);

    debugPrint(
      "🗑️ Reminder cancelled: $id",
    );
  }

  // ============================================================
  // CANCEL ALL REMINDERS
  // ============================================================

  Future<void> cancelAllReminders() async {
    await localNotifications.cancelAll();

    debugPrint("🗑️ All reminders cancelled");
  }
}