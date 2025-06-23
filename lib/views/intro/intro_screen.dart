import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../auth/login_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> pages = [
    {
      'type': 'image',
      'image': 'assets/images/img_1.png',
      'title': 'Welcome to Gainora',
      'subtitle': 'Invest smartly and track your assets with ease.',
    },
    {
      'type': 'lottie',
      'lottie': 'assets/lotties/Animation_1.json',
      'title': 'Track Market in Real-Time',
      'subtitle': 'Visualize gains, losses, and trends instantly.',
    },
    {
      'type': 'lottie',
      'lottie': 'assets/lotties/Animation_2.json',
      'title': 'Grow Your Portfolio',
      'subtitle': 'Make smarter decisions for better results.',
    },
  ];

  void _nextPage() {
    if (_currentIndex < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  final List<Color> _colorizeColors = [
    Colors.pink,
    Colors.deepPurple,
    Colors.orange,
    Colors.teal,
  ];

  final TextStyle _colorizeTextStyle = const TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: _controller,
          itemCount: pages.length,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          itemBuilder: (context, index) {
            final page = pages[index];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (page['type'] == 'image')
                    Image.asset(page['image'], height: 250)
                  else
                    Lottie.asset(page['lottie'], height: 250),

                  const SizedBox(height: 40),

                  AnimatedTextKit(
                    isRepeatingAnimation: true,
                    repeatForever: true,
                    animatedTexts: [
                      ColorizeAnimatedText(
                        page['title'],
                        textStyle: _colorizeTextStyle,
                        colors: _colorizeColors,
                        textAlign: TextAlign.center,

                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  AnimatedTextKit(
                    isRepeatingAnimation: true,
                    repeatForever: true,
                    animatedTexts: [
                      TyperAnimatedText(
                        page['subtitle'],
                        textStyle: const TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.center,
                        speed: const Duration(milliseconds: 50),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                          (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: _currentIndex == i ? 14 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == i ? Colors.pink : Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _currentIndex == pages.length - 1 ? 'Get Started' : 'Next',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
