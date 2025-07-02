import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_market_app/views/profile/terms_and_conditions.dart';
import 'package:country_flags/country_flags.dart';

import '../../main.dart';
import '../../services/theme_service.dart';
import 'buy_premium.dart';

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
  String? countryCode;

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
        countryCode = data['countryCode']; // Already saved in CompleteProfile
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                _themeService.switchTheme();
                setState(() {});
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: 65,
                height: 36,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  alignment: _themeService.isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                    ),
                    child: Icon(
                      _themeService.isDarkMode ? Icons.nights_stay : Icons.sunny,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xff0F2027),
                  Color(0xff203A43),
                  Color(0xff2C5364),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/profile_img.jpeg'),
                ),
                const SizedBox(height: 12),
                Text(
                  nickname,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Born: $birthYear',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (countryCode != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CountryFlag.fromCountryCode(countryCode!, height: 20, width: 28),
                        const SizedBox(width: 8),
                        Text(
                          countryCode!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildTile(
            Icons.monetization_on,
            'Buy Premium',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BuyPremiumScreen()),
              );
            },
          ),
          _buildTile(Icons.notifications, 'Notifications'),
          _buildTile(Icons.security, 'Security'),
          _buildTile(Icons.help_outline, 'Help and Support'),
          _buildTile(Icons.article, 'Terms and Conditions', onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreditsScreen()),
            );
          }),
          _buildTile(
            Icons.logout,
            'Log Out',
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const RootHandler()),
                      (route) => false,
                );
              }
            },
          ),
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
