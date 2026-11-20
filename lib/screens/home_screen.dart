import 'package:flutter/material.dart';
import 'package:responsi_124240085/screens/profile.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import '../api/api_services.dart'; 
import '../models/character.dart'; 
import 'character_detail_screen.dart'; 
import 'login_screen.dart'; 
import 'spell_screen.dart'; 


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    List<Character> _characters = []; // Data mentah asli dari API

 
  
  bool _isLoading = true;
  
  String _error = '';

  @override
  
  void initState() {
    super.initState();
    // Memanggil fungsi untuk mengambil data karakter dari API saat halaman pertama kali dibuka
    _fetchCharacters();
  }


  // Fungsi asynchronous untuk mengambil daftar karakter Harry Potter dari ApiService
  Future<void> _fetchCharacters() async {
    // Memperbarui state agar indikator loading muncul dan menghapus pesan error sebelumnya
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      // Memanggil fungsi getCharacters dari ApiService di folder lib/api/
      final hasil = await ApiService.getCharacters();

      // Memperbarui state dengan list karakter yang baru dan mematikan indikator loading
      setState(() {
        _characters = hasil;
        _isLoading = false;
      });

    } catch (e) {
      // Menampilkan pesan error di konsol debug jika terjadi exception / kegagalan koneksi
      debugPrint('Gagal ambil data karakter: $e');
      // Memperbarui state dengan pesan error dan mematikan indikator loading
      setState(() {
        _error = 'Gagal mengambil data karakter';
        _isLoading = false;
      });
    }
  }

  // Fungsi asynchronous untuk melakukan proses Logout akun
  Future<void> _logout() async {
    // Mengambil instance SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Menghapus data sesi login 'isLoggedIn' dari memori perangkat
    await prefs.remove('isLoggedIn');

    // Memastikan widget masih terpasang sebelum menampilkan SnackBar dan navigasi
    if (!mounted) return;

    // Menampilkan pemberitahuan SnackBar bahwa logout berhasil
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green, // Indikator sukses warna hijau
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Success!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Logged out Successfully'),
          ],
        ),
      ),
    );

    // Navigasi kembali ke LoginScreen dan menghapus seluruh riwayat halaman sebelumnya (clear stack)
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  // Membangun antarmuka utama HomeScreen
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F1F8), // Latar belakang abu-abu keunguan yang konsisten
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F1F8),
        title: Text('Harry Potter'),
        actions: [
          // Tombol logout di bagian kanan atas AppBar
          IconButton(
            icon: Icon(Icons.logout), // Ikon logout
            onPressed: _logout, // Memanggil fungsi logout saat diklik
          ),
        ],
      ),
      body: _buildBody(), // Memanggil helper method untuk menampilkan isi konten body

      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, 
        selectedItemColor: Color(0xFF6B4E71), 
        unselectedItemColor: Colors.grey, 
        onTap: (index) {
          if (index == 0) return; // Sudah di Beranda
          if (index == 1) {
            // Pindah ke SpellScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SpellScreen()),
            );
          } else if (index == 2) {
            // 👉 Buka dialog profil praktikum:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.person, color: Color(0xFF6B4E71)),
                    SizedBox(width: 8),
                    Text('Profil Pengguna'),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
              
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text('Tutup'),
                  ),
                ],
              ),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_fix_high),
            label: 'Spells',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),

    );
  }

  // Helper method untuk menentukan tampilan body sesuai kondisi state (Loading, Error, atau Tampil Data)
  Widget _buildBody() {
    // 1. Kondisi saat data masih dalam proses pengambilan dari API
    if (_isLoading) {
      return Center(child: CircularProgressIndicator()); // Menampilkan animasi loading putar di tengah layar
    }

    // 2. Kondisi jika terjadi error/kegagalan saat memuat data
    if (_error != '') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error), // Menampilkan teks pesan error
            SizedBox(height: 10),
            // Tombol untuk mencoba kembali (retry) mengambil data
            ElevatedButton(
              onPressed: _fetchCharacters,
              child: Text('Coba lagi'),
            ),
          ],
        ),
      );
    }

    
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      itemCount: _characters.length,
      itemBuilder: (context, index) {
        Character karakter = _characters[index];
        return Card(
          // Membentuk kartu dengan sudut melengkung dan garis tepi tipis
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: ListTile(
            
            leading: CircleAvatar(
              backgroundImage: NetworkImage(karakter.cover),
              onBackgroundImageError: (_, _) {},
            ),

            
            title: Text(karakter.title),

            
            subtitle: Text(karakter.releaseDate),

            // Aksi saat item baris ditekan
            onTap: () {
             
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CharacterDetailScreen(character: karakter),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
