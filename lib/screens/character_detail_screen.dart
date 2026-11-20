import 'package:flutter/material.dart'; // Mengimpor pustaka Material Design Flutter untuk elemen UI

import '../models/character.dart'; // Mengimpor model data Character

// CharacterDetailScreen menggunakan StatelessWidget karena layar ini hanya menampilkan data yang diterima tanpa perubahan state lokal
class CharacterDetailScreen extends StatelessWidget {

  final Character character;

  // Constructor yang mewajibkan pengiriman objek data
  const CharacterDetailScreen({super.key, required this.character});

  @override
  // Method build untuk menyusun tampilan halaman detail karakter
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih bersih untuk halaman detail
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F1F8),

        title: Text(character.title),
      ),
      // SingleChildScrollView digunakan agar layar dapat di-scroll vertikal jika konten melebihi tinggi layar (mencegah overflow)
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0), // Padding di seluruh sisi halaman
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Menyusun seluruh teks rata kiri
            children: [
              
              Center(
                child: Image.network(
                  character.cover, // URL foto karakter dari internet
                  height: 250, // Menetapkan tinggi gambar sebesar 250 pixel
                  fit: BoxFit.cover, // Memotong gambar secara proporsional agar mengisi area dengan rapi
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: 100, color: Colors.grey),
                ),
              ),
              SizedBox(height: 20), // Jarak pemisah antara gambar dan data detail

              _buildData('Judul', character.title),
              _buildData('Tanggal Rilis', character.releaseDate),
              _buildData('Deskripsi', character.description),
              // _buildData('Interpreted By', character.interpretedBy),
              _buildData('Halaman', character.pages.toString()),
              // _buildData('Children', daftarAnak),
              _buildData('Index', character.index.toString()), // Contoh konversi angka int ke String
            ],
          ),
        ),
      ),
    );
  }

  // Helper method untuk merender pasangan teks label (kategori) dan nilainya secara seragam dan rapi
  Widget _buildData(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0), // Memberikan jarak antar item informasi
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teks label (misal: "Full Name") dengan ukuran lebih kecil dan warna abu-abu
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          // Teks isi/nilai informasi yang ditampilkan dengan ukuran lebih besar
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
