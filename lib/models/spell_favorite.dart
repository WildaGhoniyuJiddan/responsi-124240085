import 'package:hive/hive.dart'; // Mengimpor pustaka Hive untuk anotasi database lokal NoSQL

// Menandakan bahwa file ini terhubung dengan file hasil auto-generate adapter 'spell_favorite.g.dart'
part 'spell_favorite.g.dart';

// Anotasi @HiveType mendefinisikan class ini sebagai entitas/model Hive
// typeId harus unik untuk setiap class model di aplikasi (di sini bernilai 0)
@HiveType(typeId: 0)
class SpellFavorite extends HiveObject {
  // Anotasi @HiveField(0) menetapkan indeks biner untuk menyimpan properti 'spell' di database
  @HiveField(0)
  String spell; // Nama mantra sihir yang dijadikan favorit

  // Anotasi @HiveField(1) menetapkan indeks biner untuk properti 'use'
  @HiveField(1)
  String use; // Deskripsi fungsi mantra sihir favorit

  // Anotasi @HiveField(2) menetapkan indeks biner untuk properti 'index'
  @HiveField(2)
  int index; // ID / indeks unik mantra sihir favorit

  // Constructor untuk membuat objek SpellFavorite
  SpellFavorite({
    required this.spell,
    required this.use,
    required this.index,
  });
}
