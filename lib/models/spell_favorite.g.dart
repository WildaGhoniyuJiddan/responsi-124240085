part of 'spell_favorite.dart'; // Menandakan bahwa file ini adalah bagian dari file model 'spell_favorite.dart'

// Class Adapter yang mengimplementasikan TypeAdapter untuk model SpellFavorite
class SpellFavoriteAdapter extends TypeAdapter<SpellFavorite> {
  @override
  // ID tipe harus sama persis dengan typeId yang ditentukan di @HiveType (yaitu 0)
  final int typeId = 0;

  @override
  // Fungsi read bertugas membaca byte biner dari penyimpanan Hive dan merekonstruksinya menjadi objek Dart SpellFavorite
  SpellFavorite read(BinaryReader reader) {
    // Membaca jumlah field yang tersimpan
    final numOfFields = reader.readByte();
    // Membaca key dan value setiap field ke dalam Map
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    // Mengembalikan objek SpellFavorite baru dengan memetakan field berdasarkan indeksnya
    return SpellFavorite(
      spell: fields[0] as String, // Indeks 0 adalah properti 'spell'
      use: fields[1] as String,   // Indeks 1 adalah properti 'use'
      index: fields[2] as int,    // Indeks 2 adalah properti 'index'
    );
  }

  @override
  // Fungsi write bertugas menulis objek Dart SpellFavorite ke dalam bentuk byte biner untuk disimpan di Hive
  void write(BinaryWriter writer, SpellFavorite obj) {
    writer
      ..writeByte(3) 
      ..writeByte(0)
      ..write(obj.spell) 
      ..writeByte(1) 
      ..write(obj.use)
      ..writeByte(2) 
      ..write(obj.index); 
  }

  @override
  // Menghasilkan hash code unik berdasarkan typeId untuk pembanding kesetaraan adapter
  int get hashCode => typeId.hashCode;

  @override
  // Operator perbandingan untuk memeriksa apakah dua adapter bertipe sama
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpellFavoriteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
