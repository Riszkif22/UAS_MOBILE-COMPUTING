import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterAccountPage extends StatefulWidget {
  const RegisterAccountPage({super.key});

  @override
  State<RegisterAccountPage> createState() => _RegisterAccountPageState();
}

class _RegisterAccountPageState extends State<RegisterAccountPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    // --- VALIDASI ---
    if (_nameController.text.isEmpty || _usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Semua kolom wajib diisi!")));
      return;
    }
    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password harus minimal 8 karakter!"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('https://rilah.ujangkedu.my.id/api/register_user.php'),
        body: {
          'username': _usernameController.text,
          'password': _passwordController.text,
          'full_name': _nameController.text,
        },
      );
      final data = jsonDecode(response.body);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));
        if (data['status'] == 'success') {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar Transparan agar menyatu dengan background
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('http://rilah.ujangkedu.my.id/images/6.jpg'),
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
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
          ),

          // 3. FORM REGISTER
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "CREATE ACCOUNT",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5
                    ),
                  ),
                  const SizedBox(height: 40),

                  _buildPremiumTextField(
                    controller: _nameController,
                    icon: Icons.badge_outlined,
                    label: "Full Name",
                  ),
                  const SizedBox(height: 20),

                  _buildPremiumTextField(
                    controller: _usernameController,
                    icon: Icons.person_outline,
                    label: "Username",
                  ),
                  const SizedBox(height: 20),

                  _buildPremiumTextField(
                    controller: _passwordController,
                    icon: Icons.lock_outline,
                    label: "Password",
                    isPassword: true,
                    helperText: "Min. 8 characters",
                  ),

                  const SizedBox(height: 40),

                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.orange)
                      : Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
                      ),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFFFF512F).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: _register,
                      child: const Text("REGISTER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET HELPER
  Widget _buildPremiumTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    bool isPassword = false,
    String? helperText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white30),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          helperText: helperText,
          helperStyle: const TextStyle(color: Colors.orangeAccent),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}