import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BuyPremiumScreen extends StatelessWidget {
  const BuyPremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Buy Premium')),
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Placeholder for image
              Container(
                height: 160,
                width: double.infinity,
                color: Colors.amberAccent,
                child: Lottie.asset('assets/lotties/Animation_3.json')),
              const SizedBox(height: 32),
              Text(
                'Get Premium',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[700],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Unlock all the power of this mobile tool and enjoy digital experience like never before!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 32),
              _buildPlanOption('Annual', 'First 30 days free - Then €77/Year', 'Best Value'),
              const SizedBox(height: 16),
              _buildPlanOption('Monthly', 'First 7 days free - Then \$10.99/Month'),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {},
                  child: const Text('Start 30-day free trial'),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'By placing this order, you agree to the Terms of Service and Privacy Policy.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanOption(String title, String description, [String? badge]) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.pink),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
                const SizedBox(height: 4),
                Text(description),
              ],
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            )
        ],
      ),
    );
  }
}
