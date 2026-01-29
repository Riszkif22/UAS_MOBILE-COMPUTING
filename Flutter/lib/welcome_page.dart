import 'package:flutter/material.dart';
import 'login_page.dart';
import 'app_overview_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE FULLSCREEN
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?q=80&w=1000&auto=format&fit=crop',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. GRADIENT OVERLAY
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
          ),

          // 3. KONTEN TENGAH
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end, // Konten turun ke bawah
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo Icon dengan Efek Glow
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  child: const Icon(Icons.directions_run, size: 60, color: Colors.orangeAccent),
                ),

                const SizedBox(height: 30),

                // Title
                const Text(
                  "RILAH\nMARATHON",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 0.9,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 15),

                // Subtitle
                Text(
                  "Tantang batas kemampuanmu. Jadilah juara di setiap langkah.",
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 50),

                // 4. TOMBOL
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFF512F), // Orange
                        Color(0xFFDD2476), // Pink Kemerahan
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF512F).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Transparan agar gradient terlihat
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      "MULAI SEKARANG",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // 5. TOMBOL OUTLINE (Tentang Aplikasi)
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white30, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      foregroundColor: Colors.white, // Warna efek splash
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AppOverviewPage()),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "TENTANG APLIKASI",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}