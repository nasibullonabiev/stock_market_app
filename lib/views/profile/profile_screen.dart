import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/theme_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ThemeService _themeService = ThemeService();
  String nickname = 'User';
  String email = '';
  String birthYear = 'Unknown';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();

    if (data != null) {
      setState(() {
        nickname = data['nickname'] ?? 'User';
        email = data['email'] ?? 'unknown@mail.com';
        birthYear = data['birthYear']?.toString() ?? 'Unknown';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          Switch(
            value: _themeService.isDarkMode,
            onChanged: (_) {
              _themeService.switchTheme();
              setState(() {});
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade800,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                ),
                const SizedBox(height: 12),
                Text(nickname,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(email, style: const TextStyle(color: Colors.white70)),
                Text('Born: $birthYear', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildTile(Icons.monetization_on, 'Buy Premium'),
          _buildTile(Icons.notifications, 'Notifications'),
          _buildTile(Icons.security, 'Security'),
          _buildTile(Icons.help_outline, 'Help and Support'),
          _buildTile(Icons.article, 'Terms and Conditions'),
          _buildTile(Icons.logout, 'Log Out', onTap: () async {
            await FirebaseAuth.instance.signOut();
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          }),
        ],
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
