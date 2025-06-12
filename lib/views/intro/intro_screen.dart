import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../auth/login_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Track Your Stocks",
          body: "Monitor real-time market data and stock performance.",
          image: _buildImageBox("1"),
          decoration: _pageDecoration(),
        ),
        PageViewModel(
          title: "Build Your Portfolio",
          body: "Easily manage and analyze your stock investments.",
          image: _buildImageBox("2"),
          decoration: _pageDecoration(),
        ),
        PageViewModel(
          title: "Stay Informed",
          body: "Read daily news and updates about financial markets.",
          image: _buildImageBox("3"),
          decoration: _pageDecoration(),
        ),
      ],
      onDone: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      ),
      onSkip: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      ),
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.bold)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.grey,
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.pink,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  Widget _buildImageBox(String index) {
    return Container(
      height: 250,
      width: 250,
      decoration: BoxDecoration(
        color: Colors.primaries[int.parse(index) % Colors.primaries.length].shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(child: Text("Image $index", style: const TextStyle(fontSize: 18))),
    );
  }

  PageDecoration _pageDecoration() {
    return const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      bodyTextStyle: TextStyle(fontSize: 16),
      imagePadding: EdgeInsets.all(24),
      contentMargin: EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
