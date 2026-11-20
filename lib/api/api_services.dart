import 'dart:convert'; 
import 'package:flutter/foundation.dart'; 
import 'package:http/http.dart' as http; 
import '../models/character.dart'; 
import '../models/spell.dart';

class ApiService {
  
  static const String _baseUrl = 'https://potterapi-fedeperin.vercel.app/en';

  static Future<List<Character>> getCharacters() async {
    
    final url = Uri.parse('$_baseUrl/books');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
      
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Character.fromJson(item)).toList();
      } else {
    
        throw Exception(
          'Gagal mengambil data karakter: Server merespons dengan status ${response.statusCode}',
        );
      }
    } catch (e) {
      // Mencetak error di konsol debug untuk keperluan troubleshooting
      debugPrint('Terjadi kesalahan pada ApiService.getCharacters: $e');
      // Melempar kembali error agar bisa ditangkap oleh blok catch di Screen
      rethrow;
    }
  }

  
  static Future<List<Spell>> getSpells() async {
    
    final url = Uri.parse('$_baseUrl/spells');

    try {
      // Melakukan HTTP GET request ke URL endpoint
      final response = await http.get(url);

      // Memeriksa apakah response berhasil (status 200 OK)
      if (response.statusCode == 200) {
        // Mendekode JSON string menjadi List dinamis
        final List<dynamic> data = jsonDecode(response.body);

        // Memetakan setiap item JSON ke instance model Spell
        return data.map((item) => Spell.fromJson(item)).toList();
      } else {
        // Melempar Exception jika respons gagal
        throw Exception(
          'Gagal mengambil data spells: Server merespons dengan status ${response.statusCode}',
        );
      }
    } catch (e) {
      // Mencetak error di konsol debug
      debugPrint('Terjadi kesalahan pada ApiService.getSpells: $e');
      // Melempar error ke Screen
      rethrow;
    }
  }
}
