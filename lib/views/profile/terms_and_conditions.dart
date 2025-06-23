import 'package:flutter/material.dart';

class CreditsScreen extends StatefulWidget {
  const CreditsScreen({super.key});

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scrollAnimation;
  final double _scrollHeight = 1000;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..forward();

    _scrollAnimation = Tween<double>(begin: 1, end: -1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image with dark overlay
          SizedBox.expand(
            child: Image.asset(
              'assets/images/Img_3.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),

          // Scrolling text
          AnimatedBuilder(
            animation: _scrollAnimation,
            builder: (context, child) {
              return Align(
                alignment: Alignment(0, _scrollAnimation.value),
                child: child,
              );
            },
            child: SizedBox(
              height: _scrollHeight,
              width: double.infinity,
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80),
                  Text(
                    'GAINORA',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Image.asset('assets/images/img.png',height: 200,width: 200,),
                  SizedBox(height: 30),
                  Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 50),
                  Text('Developed by:', style: _headerStyle),
                  SizedBox(height: 8),
                  Text('Your Name', style: _creditStyle),
                  SizedBox(height: 20),
                  Text('UI/UX Design:', style: _headerStyle),
                  SizedBox(height: 8),
                  Text('Designer Name', style: _creditStyle),
                  SizedBox(height: 20),
                  Text('Powered by:', style: _headerStyle),
                  SizedBox(height: 8),
                  Text('Flutter • Firebase • Hive • REST APIs', style: _creditStyle),
                  Spacer(),
                  Text('© 2025 Gainora Inc.', style: TextStyle(color: Colors.white54)),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Back button
          SafeArea(
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }
}

const TextStyle _headerStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const TextStyle _creditStyle = TextStyle(
  fontSize: 16,
  color: Colors.white70,
);
