class Spell {
  
  final String spell;
  final String use;
  final int index;
  Spell({
    required this.spell,
    required this.use,
    required this.index,
  });

  // Factory constructor untuk mengonversi data Map JSON dari API menjadi objek Spell
  factory Spell.fromJson(Map<String, dynamic> json) {
    return Spell(
      spell: json['spell'] ?? '-',
      use: json['use'] ?? '-',
      index: json['index'] ?? 0,
    );
  }
}
