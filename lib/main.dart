import 'package:flutter/material.dart'; // Mengimpor pustaka Material Design Flutter untuk komponen antarmuka (UI)
import 'package:hive_flutter/hive_flutter.dart'; // Mengimpor Hive untuk database lokal NoSQL yang cepat dan ringan
import 'package:shared_preferences/shared_preferences.dart'; // Mengimpor SharedPreferences untuk penyimpanan data sesi sederhana (key-value)

import 'notification_helper.dart'; // Mengimpor file helper untuk konfigurasi notifikasi lokal
import 'models/spell_favorite.dart'; // Mengimpor model Hive SpellFavorite
import 'screens/home_screen.dart'; // Mengimpor layar beranda (daftar karakter Harry Potter)
import 'screens/login_screen.dart'; // Mengimpor layar login

// Fungsi utama (entry point) tempat aplikasi pertama kali dieksekusi
// Ditandai dengan 'async' karena ada operasi inisialisasi yang membutuhkan waktu (asynchronous)
void main() async {
  // Memastikan bahwa framework engine Flutter telah siap sebelum menjalankan kode async lainnya
  WidgetsFlutterBinding.ensureInitialized();

  // Menginisialisasi Hive untuk Flutter (menentukan lokasi penyimpanan lokal di perangkat)
  await Hive.initFlutter();

  // Mendaftarkan TypeAdapter untuk model SpellFavorite agar Hive mengerti cara membaca dan menulis objek tersebut
  Hive.registerAdapter(SpellFavoriteAdapter());

  // Membuka database (box) Hive dengan nama 'favorites' bertipe data SpellFavorite
  await Hive.openBox<SpellFavorite>('favorites');

  // Menginisialisasi service notifikasi lokal (pengaturan channel, ikon, dan permission)
  await initNotification();

  // Mengambil instance SharedPreferences untuk memeriksa status sesi login pengguna
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Membaca nilai boolean dari key 'isLoggedIn'
  // Operator '?? false' berarti jika nilainya null (belum pernah login), maka dianggap false
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Menjalankan aplikasi utama dengan membawa status login
  runApp(MainApp(isLoggedIn: isLoggedIn));
}

// Widget root aplikasi bertipe StatelessWidget karena konfigurasi utamanya bersifat statis
class MainApp extends StatelessWidget {
  // Variabel untuk menyimpan apakah user sudah login atau belum
  final bool isLoggedIn;

  // Constructor MainApp dengan parameter wajib isLoggedIn
  const MainApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    // MaterialApp adalah widget pembungkus utama aplikasi berbasis Material Design
    return MaterialApp(
      // Menonaktifkan banner tulisan 'DEBUG' di pojok kanan atas layar
      debugShowCheckedModeBanner: false,
      // Menentukan halaman awal: jika sudah login tampilkan HomeScreen, jika belum tampilkan LoginScreen
      home: isLoggedIn ? HomeScreen() : LoginScreen(),
    );
  }
}
