import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:country_flags/country_flags.dart';

import '../../main_navigation.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String uid;
  const CompleteProfileScreen({super.key, required this.uid});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _nameController = TextEditingController();
  int _selectedYear = DateTime.now().year - 18;
  bool _loading = false;
  String? _countryCode;

  @override
  void initState() {
    super.initState();
    _fetchCountry();
  }

  Future<void> _fetchCountry() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        setState(() {
          _countryCode = placemarks.first.isoCountryCode; // 'US', 'DE', etc.
        });
      }
    } catch (e) {
      debugPrint("Failed to fetch country: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showCupertinoYearPicker() {
    final currentYear = DateTime.now().year;
    final minYear = currentYear - 100;
    final maxYear = currentYear;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Enter Your Birth Year', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: maxYear - 18 - minYear),
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      _selectedYear = minYear + index;
                    });
                  },
                  children: List<Widget>.generate(maxYear - minYear + 1, (index) {
                    return Center(child: Text((minYear + index).toString()));
                  }),
                ),
              ),
              CupertinoButton(
                child: const Text("Done"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final email = FirebaseAuth.instance.currentUser?.email;
    final currentYear = DateTime.now().year;
    final age = currentYear - _selectedYear;

    if (name.isEmpty || email == null) {
      _showError('Please fill in all fields.');
      return;
    }

    if (age < 18) {
      _showError('You must be at least 18 years old to use this app.');
      return;
    }

    setState(() => _loading = true);

    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.uid).set({
        'nickname': name,
        'birthYear': _selectedYear,
        'age': age,
        'email': email,
        'countryCode': _countryCode,
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
            (route) => false,
      );
    } catch (e) {
      _showError('Failed to save profile: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Your Profile")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Your Name'),
            ),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: _showCupertinoYearPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Birth Year: $_selectedYear', style: const TextStyle(fontSize: 16)),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (_countryCode != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CountryFlag.fromCountryCode(_countryCode!, height: 24, width: 32),
                  const SizedBox(width: 8),
                  Text('$_countryCode'),
                ],
              ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[700],
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
              ),
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Continue to App', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
