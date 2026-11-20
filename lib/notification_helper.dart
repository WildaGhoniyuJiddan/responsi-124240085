import 'package:flutter_local_notifications/flutter_local_notifications.dart'; 

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Fungsi untuk menginisialisasi konfigurasi notifikasi saat aplikasi dibuka
Future<void> initNotification() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  // Menggabungkan konfigurasi inisialisasi untuk berbagai platform (Android, iOS jika ada)
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Menerapkan konfigurasi inisialisasi ke plugin notifikasi
  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
  );

  
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
}

Future<void> showNotification(String title, String body) async {
  // Konfigurasi detail notifikasi untuk platform Android
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'favorite_channel',
    'Favorite Spell', 
    channelDescription: 'Notifikasi untuk spell favorite', 
    importance: Importance.max, 
    priority: Priority.high, // Prioritas tinggi agar langsung diproses oleh sistem Android
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  // Menampilkan notifikasi ke layar perangkat
  await flutterLocalNotificationsPlugin.show(
    id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title: title, // Judul notifikasi yang ditampilkan
    body: body, // Isi teks pesan notifikasi yang ditampilkan
    notificationDetails: notificationDetails, // Detail konfigurasi tampilan dan suara notifikasi
  );
}
