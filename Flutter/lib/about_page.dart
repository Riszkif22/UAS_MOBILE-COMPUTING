import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CONTAINER GAMBAR
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[300], // Warna dasar jika loading
              image: const DecorationImage(
                image: NetworkImage(
                  'https://rilah.ujangkedu.my.id/images/1.jpeg',
                ),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // JUDUL
          const Text(
              "Tentang Rilah Marathon",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
          ),

          const SizedBox(height: 15),

          // ISI ARTIKEL
          const Text(
            "Rilah Marathon adalah aplikasi pendaftaran lomba lari terpercaya. "
                "Kami menyediakan berbagai kategori mulai dari 5K untuk pemula hingga Full Marathon 42K "
                "untuk para profesional.\n\n"
                "Visi kami adalah menyehatkan masyarakat melalui olahraga lari yang menyenangkan dan terorganisir. "
                "Bergabunglah dengan ribuan pelari lainnya dan raih garis finish impian Anda!",
            style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
            textAlign: TextAlign.justify,
          ),

          const SizedBox(height: 200),
        ],
      ),
    );
  }
}