import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Mengimpor pustaka flutter_local_notifications untuk menampilkan notifikasi lokal di perangkat

// Membuat instance tunggal (singleton/global) dari FlutterLocalNotificationsPlugin
// Instance ini digunakan untuk mengonfigurasi dan memicu notifikasi di seluruh aplikasi
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Fungsi untuk menginisialisasi konfigurasi notifikasi saat aplikasi dibuka
Future<void> initNotification() async {
  // Menentukan ikon default yang akan tampil di notifikasi bar untuk perangkat Android
  // 'app_icon' merujuk pada nama file ikon di android/app/src/main/res/drawable/app_icon.png
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

  // Meminta izin pengiriman notifikasi khusus untuk sistem operasi Android 13 (API level 33) ke atas
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
}

// Fungsi asynchronous untuk menampilkan notifikasi pop-up kepada pengguna
// Menerima dua parameter string: title (judul notifikasi) dan body (pesan notifikasi)
Future<void> showNotification(String title, String body) async {
  // Konfigurasi detail notifikasi untuk platform Android
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'favorite_channel', // ID unik channel notifikasi
    'Favorite Spell', // Nama channel yang terlihat di pengaturan aplikasi oleh user
    channelDescription: 'Notifikasi untuk spell favorite', // Penjelasan fungsi channel notifikasi
    importance: Importance.max, // Tingkat kepentingan maksimal agar notifikasi muncul sebagai pop-up (heads-up)
    priority: Priority.high, // Prioritas tinggi agar langsung diproses oleh sistem Android
  );

  // Menggabungkan detail konfigurasi platform ke dalam satu objek NotificationDetails
  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  // Menampilkan notifikasi ke layar perangkat
  await flutterLocalNotificationsPlugin.show(
    // ID unik untuk notifikasi, dibuat dinamis dari milidetik waktu saat ini dibagi 1000 agar tidak bertabrakan
    id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title: title, // Judul notifikasi yang ditampilkan
    body: body, // Isi teks pesan notifikasi yang ditampilkan
    notificationDetails: notificationDetails, // Detail konfigurasi tampilan dan suara notifikasi
  );
}
