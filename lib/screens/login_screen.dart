import 'package:flutter/material.dart'; // Mengimpor komponen antarmuka Material Design
import 'package:shared_preferences/shared_preferences.dart'; // Mengimpor SharedPreferences untuk menyimpan data sesi pengguna secara persisten

import 'home_screen.dart'; // Mengimpor HomeScreen untuk navigasi setelah login berhasil

// LoginScreen menggunakan StatefulWidget karena layar ini mengelola input teks dan state dinamis
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // Membuat state yang akan mengontrol logika dan tampilan layar login
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller untuk membaca dan mengontrol teks input username
  final TextEditingController _usernameController = TextEditingController();
  // Controller untuk membaca dan mengontrol teks input password
  final TextEditingController _passwordController = TextEditingController();

  @override
  // Method dispose dipanggil ketika widget dihapus dari pohon widget (widget tree)
  // Sangat penting untuk menghapus controller agar tidak terjadi kebocoran memori (memory leak)
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi asynchronous untuk memproses autentikasi login
  Future<void> _login() async {
    // Mengambil nilai teks dari controller dan menghapus spasi berlebih di awal/akhir menggunakan trim()
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    // Validasi login statis (demo login: username 'username' dan password 'password')
    if (username == 'Wilda Ghoniyu Jiddan' && password == '085') {
      // Mengakses instance SharedPreferences untuk menyimpan sesi
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Menyimpan nilai boolean bahwa user sudah berhasil login
      await prefs.setBool('isLoggedIn', true);
      // Menyimpan string username yang sedang aktif
      await prefs.setString('username', username);

      // Pengecekan apakah widget masih terpasang (mounted) di layar sebelum menggunakan BuildContext
      // Ini mencegah error jika operasi asynchronous selesai saat user sudah meninggalkan layar
      if (!mounted) return;

      // Menampilkan SnackBar berwarna hijau sebagai notifikasi keberhasilan login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green, // Warna hijau menandakan operasi sukses
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Success!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Logged in Successfully'),
            ],
          ),
        ),
      );

      // Berpindah ke HomeScreen dan menggantikan LoginScreen di navigation stack
      // Pengguna tidak dapat menekan tombol kembali (back button) untuk kembali ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // Jika username atau password tidak cocok, tampilkan SnackBar berwarna merah (gagal)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red, // Warna merah menandakan error/gagal
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Failed!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Wrong username or password'),
            ],
          ),
        ),
      );
    }
  }

  @override
  // Method build untuk merender tata letak visual layar login
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F1F8), // Warna latar belakang abu-abu keunguan yang lembut
      body: Center(
        // Menempatkan kotak login tepat di tengah-tengah layar
        child: Padding(
          padding: EdgeInsets.all(20.0), // Memberi jarak tepi di sekeliling kartu
          child: Card(
            // Mengatur bentuk kartu dengan sudut melengkung beradius 20
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0), // Jarak di dalam isi kartu
              child: Column(
                // mainAxisSize.min membuat ukuran tinggi Column menyesuaikan dengan kontennya (tidak memanjang penuh)
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Judul form login
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8), // Jarak pemisah vertikal sebesar 8 pixel
                  // Petunjuk akun demo untuk mempermudah penguji/dosen
                  Text('Demo login: username / password'),
                  SizedBox(height: 20),
                  // Input field untuk Username
                  TextField(
                    controller: _usernameController, // Menghubungkan input dengan controller username
                    decoration: InputDecoration(
                      hintText: 'Username', // Teks petunjuk saat form masih kosong
                      enabledBorder: UnderlineInputBorder(), // Garis bawah saat input dalam keadaan aktif/normal
                    ),
                  ),
                  SizedBox(height: 10),
                  // Input field untuk Password
                  TextField(
                    controller: _passwordController, // Menghubungkan input dengan controller password
                    obscureText: true, // Menyembunyikan karakter password menjadi titik-titik demi keamanan
                    decoration: InputDecoration(
                      hintText: 'Password',
                      enabledBorder: UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 25),
                  // Tombol Login yang dibungkus SizedBox agar lebarnya penuh (full width)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _login, // Memanggil fungsi _login saat tombol ditekan
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.deepPurple), // Warna teks tombol ungu
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
