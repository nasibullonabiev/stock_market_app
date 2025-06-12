import 'package:flutter/material.dart';

class StockDetailScreen extends StatelessWidget {
  final String name;
  final double price;
  final double change;

  const StockDetailScreen({
    super.key,
    required this.name,
    required this.price,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPositive = change >= 0;
    final Color changeColor = isPositive ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '€${price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 18, color: changeColor),
            ),
            const SizedBox(height: 24),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey.shade300,
              alignment: Alignment.center,
              child: const Text('Chart Placeholder'),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var label in ['1H', '24H', '1W', '1M', '1Y', 'All'])
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text(label),
                      ),
                    )
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('$name\nHolding: 0.00', style: const TextStyle(fontSize: 16)),
            const Text('€0.00', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            const Text('Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('No transactions yet.'),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[700]),
                    child: const Text('BUY'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[700]),
                    child: const Text('SELL'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
