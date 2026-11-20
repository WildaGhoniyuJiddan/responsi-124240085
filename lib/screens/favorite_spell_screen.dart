import 'package:flutter/material.dart'; 
import 'package:hive/hive.dart'; 
import '../models/spell_favorite.dart'; 
import '../notification_helper.dart'; 

class FavoriteSpellScreen extends StatefulWidget {
  const FavoriteSpellScreen({super.key});

  @override
  State<FavoriteSpellScreen> createState() => _FavoriteSpellScreenState();
}

class _FavoriteSpellScreenState extends State<FavoriteSpellScreen> {
  late Box<SpellFavorite> _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<SpellFavorite>('favorites');
  }

    Future<void> _deleteFavorite(int key, String namaSpell) async {
      await _box.delete(key);

      if (!mounted) return;

      setState(() {});

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
            
            Text('$namaSpell removed from fav list!'),
          ],
        ),
      ),
    );

    await showNotification(
      'Delete notification',
      'You deleted $namaSpell from your fav list!',
    );
  }

  @override
  // Membangun tampilan antarmuka layar FavoriteSpellScreen
  Widget build(BuildContext context) {
    // Mengambil semua nilai (objek SpellFavorite) yang tersimpan di dalam Box Hive dan mengubahnya menjadi List
    List<SpellFavorite> daftarFavorite = _box.values.toList();
    // Mengambil semua kunci (keys) dari Box Hive dan mengubah tipenya menjadi List<int>
    // Kunci ini digunakan untuk menentukan item mana yang akan dihapus dari database
    List<int> daftarKey = _box.keys.cast<int>().toList();

    return Scaffold(
      backgroundColor: Color(0xFFF5F1F8), // Latar belakang abu-abu keunguan yang konsisten
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F1F8),
        
        title: Text('Favorite Spell'),
      ),
      
      body: daftarFavorite.isEmpty
          
          ? Center(child: Text('Belum ada spell favorite'))
          : ListView.builder(
              padding: EdgeInsets.all(12.0), // Padding di sekeliling daftar item
              
              itemCount: daftarFavorite.length,
              itemBuilder: (context, index) {
                
                SpellFavorite data = daftarFavorite[index];

                return Card(
                  // Desain kartu dengan sudut melengkung dan garis tepi abu-abu tipis
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: ListTile(
                   
                    leading: Icon(Icons.menu_book),

                    
                    title: Text(data.spell),

                    
                    subtitle: Text(data.use),

                    // Tombol hapus di sisi kanan kartu
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red), // Ikon tempat sampah warna merah
                      onPressed: () {
                        
                        _deleteFavorite(daftarKey[index], data.spell);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
