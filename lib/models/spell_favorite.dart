import 'package:hive/hive.dart'; 
part 'spell_favorite.g.dart';

@HiveType(typeId: 0)
class SpellFavorite extends HiveObject {
  @HiveField(0)
  String spell; // Nama mantra sihir yang dijadikan favorit

  @HiveField(1)
  String use; // Deskripsi fungsi mantra sihir favorit

  @HiveField(2)
  int index; // ID / indeks unik mantra sihir favorit

  SpellFavorite({
    required this.spell,
    required this.use,
    required this.index,
  });
}
