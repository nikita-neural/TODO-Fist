import 'dart:convert';
import 'dart:math';
import 'dart:async' as dart_async;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:list_app/models/Item.dart';

// Background message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Background Message: ${message.messageId}');
}

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  
  static final Map<int, dart_async.Timer?> _periodicTimers = {};

  // Инициализация уведомлений
  static Future<void> initialize() async {
    // Инициализация timezone
    tz.initializeTimeZones();
    
    try {
      // Запрос разрешений для iOS
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('Пользователь разрешил уведомления');
      } else {
        debugPrint('Пользователь запретил уведомления');
      }

      // Настройка локальных уведомлений
      await _initializeLocalNotifications();

      // Получение FCM токена (только для физических устройств)
      String? token = await _firebaseMessaging.getToken().catchError((e) {
        debugPrint('Ошибка получения FCM токена (нормально для симулятора): $e');
        return null;
      });
      
      if (token != null) {
        debugPrint('FCM Token: $token');
      } else {
        debugPrint('FCM токен недоступен (возможно, это симулятор)');
      }

      // Настройка обработчиков сообщений
      _setupMessageHandlers();
    } catch (e) {
      debugPrint('Ошибка инициализации уведомлений: $e');
    }
  }

  // Инициализация локальных уведомлений
  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        debugPrint('Notification clicked: ${details.payload}');
      },
    );

    // Создаем канал уведомлений для Android
    await _createNotificationChannel();
  }

  // Создание канала уведомлений с кастомными настройками
  static Future<void> _createNotificationChannel() async {
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      'list_app_channel',
      'List App Notifications',
      description: 'Уведомления для приложения List App',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 500, 250, 500]),
      sound: const RawResourceAndroidNotificationSound('notification_sound'),
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Настройка обработчиков сообщений
  static void _setupMessageHandlers() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground Message: ${message.notification?.title}');
      _showLocalNotification(
        title: message.notification?.title ?? 'Уведомление',
        body: message.notification?.body ?? '',
        payload: jsonEncode(message.data),
      );
    });

    // Background/terminated app messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('App opened from notification: ${message.notification?.title}');
    });
  }

  // Показать локальное уведомление
  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'list_app_channel',
      'List App Notifications',
      channelDescription: 'Уведомления для приложения List App',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/ic_notification',
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 500, 250, 500]),
      sound: const RawResourceAndroidNotificationSound('notification_sound'),
      styleInformation: BigTextStyleInformation(body),
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'notification_sound.caf',
    );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      Random().nextInt(1000),
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  // Настроить периодические напоминания для задачи
  static Future<void> setupPeriodicReminder(Item item) async {
    if (!item.reminderEnabled || item.reminderPeriodMinutes == null || item.isDone) {
      return;
    }

    // Отменяем существующий таймер для этой задачи
    _periodicTimers[item.id]?.cancel();

    // Создаем новый периодический таймер
    _periodicTimers[item.id] = dart_async.Timer.periodic(
      Duration(microseconds: (item.reminderPeriodMinutes! * 60 * 1000000).round()),
      (timer) async {
        // Проверяем, что задача все еще не выполнена
        await _showLocalNotification(
          title: 'Напоминание: ${item.title}',
          body: item.description.isNotEmpty ? 'Не забудьте выполнить задачу: ${item.description}' : '',
          payload: jsonEncode({'taskId': item.id}),
        );
        
        // Также отправляем push уведомление
        await _sendReminderPushNotification(item);
      },
    );
  }

  // Отменить периодические напоминания для задачи
  static void cancelPeriodicReminder(int taskId) {
    _periodicTimers[taskId]?.cancel();
    _periodicTimers.remove(taskId);
  }

  // Отправить push уведомление-напоминание
  static Future<void> _sendReminderPushNotification(Item item) async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token == null) return;

      // В реальном приложении это должно отправляться с сервера
      debugPrint('Sending push reminder for task: ${item.title}');
      
    } catch (e) {
      debugPrint('Error sending push notification: $e');
    }
  }

  // Показать тестовое уведомление
  static Future<void> showTestNotification() async {
    await _showLocalNotification(
      title: 'Тестовое уведомление',
      body: 'Уведомления работают корректно!',
    );
  }

  // Получить FCM токен
  static Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  // Подписаться на топик
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }

  // Отписаться от топика
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
    }
  }

  // Очистить все напоминания
  static void clearAllReminders() {
    for (var timer in _periodicTimers.values) {
      timer?.cancel();
    }
    _periodicTimers.clear();
  }
}