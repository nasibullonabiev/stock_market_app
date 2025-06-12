import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/stock_tile.dart';
import '../stock/stock_detail_screen.dart';
import '../../models/stock_model.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  Future<Map<String, dynamic>> _fetchPortfolio() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return {};
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data() ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchPortfolio(),
      builder: (context, snapshot) {
        final data = snapshot.data ?? {};
        final holding = data['holdingValue'] ?? 2509.75;
        final invested = data['investedValue'] ?? 1618.75;
        final available = data['availableEuro'] ?? 1589.0;

        return Scaffold(
          appBar: AppBar(title: const Text('Portfolio')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade800,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Portfolio',
                          style: TextStyle(color: Colors.white70, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(
                        '€${holding.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text('+9.77%',
                          style: TextStyle(color: Colors.greenAccent)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Invested: €${invested.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.white)),
                          Text('Available: €${available.toStringAsFixed(0)}',
                              style: const TextStyle(color: Colors.white)),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: null,
                      child: Text('Deposit EURO'),
                    ),
                    ElevatedButton(
                      onPressed: null,
                      child: Text('Withdraw EURO'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Your stocks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: dummyStocks.length,
                    itemBuilder: (context, index) {
                      final stock = dummyStocks[index];
                      return StockTile(
                        name: stock.name,
                        symbol: stock.symbol,
                        price: stock.price,
                        change: stock.change,
                        logoUrl: stock.logoUrl,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StockDetailScreen(
                                name: stock.name,
                                price: stock.price,
                                change: stock.change,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
