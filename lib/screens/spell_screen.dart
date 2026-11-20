import 'package:flutter/material.dart'; 
import 'package:hive/hive.dart';
import 'package:responsi_124240085/screens/profile.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import '../api/api_services.dart';
import '../models/spell.dart'; 
import '../models/spell_favorite.dart'; 
// ignore: unused_import
import 'home_screen.dart'; 
import 'favorite_spell_screen.dart'; 
import 'login_screen.dart'; 


class SpellScreen extends StatefulWidget {
  const SpellScreen({super.key});

  @override
  // Membuat state yang mengelola logika SpellScreen
  State<SpellScreen> createState() => _SpellScreenState();
}

class _SpellScreenState extends State<SpellScreen> {
 
  List<Spell> _spells = []; // Data mentah asli dari API

  bool _isLoading = true;
  // Variabel untuk menyimpan pesan kesalahan jika request API gagal
  String _error = '';

 
  late Box<SpellFavorite> _box;

  @override
  // Inisialisasi awal saat layar pertama kali dimuat
  void initState() {
    super.initState();
    
    _box = Hive.box<SpellFavorite>('favorites');
    // Memanggil fungsi untuk mengunduh daftar mantra sihir dari API
    _fetchSpells();
  }

 
  Future<void> _fetchSpells() async {
    // Memperbarui UI untuk memunculkan indikator loading
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      // Memanggil fungsi getSpells dari ApiService di folder lib/api/
      final hasil = await ApiService.getSpells();

      // Memperbarui state dengan daftar mantra yang berhasil diambil dan mematikan loading
      setState(() {
        _spells = hasil;
        _isLoading = false;
      });

    } catch (e) {
      // Menampilkan pesan error di konsol jika terjadi error jaringan atau parsing
      debugPrint('Gagal ambil data spell: $e');
      setState(() {
        _error = 'Gagal mengambil data spell';
        _isLoading = false;
      });
    }
  }

  
  bool _isFavorite(Spell spell) {
    return _box.containsKey(spell.index);
  }

  // Fungsi untuk menambah atau menghapus mantra dari database favorit Hive (Toggle)
  Future<void> _toggleFavorite(Spell spell) async {
    // Jika mantra sudah ada di daftar favorit, maka hapus dari Hive
    if (_isFavorite(spell)) {
      
      await _box.delete(spell.index);

      // Memastikan widget masih aktif sebelum melakukan perubahan state dan memanggil context
      if (!mounted) return;
      // Memperbarui tampilan ikon hati (berubah dari merah penuh menjadi outline)
      setState(() {});

      // Menampilkan notifikasi SnackBar berwarna merah bahwa mantra dihapus dari favorit
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Remove!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              
              Text('${spell.spell} removed from fav list!'),
            ],
          ),
        ),
      );
    } else {
     
      await _box.put(
        spell.index, // Kunci unik penyimpanan (Key)
        SpellFavorite(
          spell: spell.spell,
          use: spell.use,
          index: spell.index,
        ),
      );

      // Memastikan widget masih aktif
      if (!mounted) return;
      // Memperbarui tampilan ikon hati (berubah menjadi ikon hati merah penuh)
      setState(() {});

      // Menampilkan notifikasi SnackBar berwarna hijau bahwa mantra berhasil ditambahkan ke favorit
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              
              Text('${spell.spell} successfully added to fav list!'),
            ],
          ),
        ),
      );
    }
  }

  // Fungsi untuk logout dan menghapus sesi pengguna
  Future<void> _logout() async {
    // Mengakses SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Menghapus data login
    await prefs.remove('isLoggedIn');

    if (!mounted) return;
    // Menampilkan pesan logout berhasil
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
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

    // Berpindah ke LoginScreen dan mengosongkan riwayat navigasi
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  // Membangun tampilan utama SpellScreen
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F1F8), // Latar belakang abu-abu keunguan yang konsisten
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F1F8),
        
        title: Text('Harry Potter Spells Gallery'),
        actions: [
          // Tombol logout di AppBar
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _buildBody(), // Menampilkan isi konten utama (Loading/Error/List)
      // Tombol mengapung (FloatingActionButton) untuk membuka halaman FavoriteSpellScreen
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFE8D9F5), // Warna latar tombol ungu muda
        onPressed: () {
          // Berpindah ke halaman FavoriteSpellScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FavoriteSpellScreen()),
          ).then((_) {
            // Blok .then() akan dieksekusi saat kembali dari FavoriteSpellScreen
            // setState() dipanggil agar status ikon hati langsung diperbarui jika ada item yang dihapus di halaman favorit
            setState(() {});
          });
        },
        child: Icon(Icons.favorite, color: Colors.red), // Ikon hati berwarna merah
      ),
      // =======================================================================
      // 🟢 [PILIHAN 1: BOTTOM NAVIGATION BAR 3 MENU (Beranda, Spell, Profile)]
      // Status: SAAT INI DINONAKTIFKAN (DIBERI '//').
      // 👉 CARA MENGAKTIFKAN:
      //    1. Hapus tanda '//' pada blok di bawah ini (bisa blok lalu tekan Ctrl + / di VS Code).
      //    2. Pastikan blok Pilihan 2 di bawahnya tetap dalam keadaan '//' (mati).
      // =======================================================================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Indeks 1 aktif (Spells)
        selectedItemColor: Color(0xFF6B4E71), // Warna tab aktif
        unselectedItemColor: Colors.grey, // Warna tab non-aktif
        onTap: (index) {
          if (index == 0) {
            // Pindah kembali ke Beranda (HomeScreen)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            return; // Sudah di halaman Spells
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

  // Helper method untuk menampilkan konten body sesuai status data
  Widget _buildBody() {
    // 1. Tampilan saat proses pengambilan data dari API sedang berjalan
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // 2. Tampilan saat terjadi error saat mengambil data
    if (_error != '') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchSpells, // Menjalankan ulang fetch data
              child: Text('Coba lagi'),
            ),
          ],
        ),
      );
    }

    
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      itemCount: _spells.length,
      itemBuilder: (context, index) {
        Spell spell = _spells[index];

        return Card(
          // Desain kartu dengan sudut melengkung dan garis tepi tipis
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: ListTile(
            
            leading: Icon(Icons.menu_book),
            title: Text(spell.spell),
            subtitle: Text(spell.use),

            // Tombol ikon di sisi kanan kartu untuk toggle favorit
            trailing: IconButton(
              icon: Icon(
                
                _isFavorite(spell) ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite(spell) ? Colors.red : Colors.black87,
              ),
              onPressed: () {
                // Memanggil fungsi toggle favorit saat tombol ditekan
                _toggleFavorite(spell);
              },
            ),
          ),
        );
      },
    );
  }
}
