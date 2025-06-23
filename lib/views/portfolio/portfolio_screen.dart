import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/stock_tile.dart';
import '../../models/stock_model.dart';
import '../../services/stock_api_service.dart';
import '../stock/stock_detail_screen.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final StockApiService _stockApiService = StockApiService();
  late Future<Map<String, dynamic>> _portfolioFuture;
  late Future<List<StockModel>> _cachedStocksFuture;

  @override
  void initState() {
    super.initState();
    _portfolioFuture = _fetchPortfolio();
    _cachedStocksFuture = _stockApiService.fetchStocks(); // from cache
  }

  Future<Map<String, dynamic>> _fetchPortfolio() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return {};
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data() ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Portfolio')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _portfolioFuture,
        builder: (context, snapshot) {
          final data = snapshot.data ?? {};
          final holding = data['holdingValue'] ?? 2509.75;
          final invested = data['investedValue'] ?? 1618.75;
          final available = data['availableEuro'] ?? 1589.0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(holding, invested, available),
                const SizedBox(height: 24),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: null, child: Text('Deposit EURO')),
                    ElevatedButton(onPressed: null, child: Text('Withdraw EURO')),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Your stocks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Expanded(
                  child: FutureBuilder<List<StockModel>>(
                    future: _cachedStocksFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No stock data available'));
                      }

                      final stocks = snapshot.data!;

                      // TODO: replace this dummy filter with real user holdings in future
                      final userStocks = stocks.where((s) =>
                      s.symbol == 'AAPL' || s.symbol == 'TSLA').toList();

                      return ListView.builder(
                        itemCount: userStocks.length,
                        itemBuilder: (context, index) {
                          final stock = userStocks[index];
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
                                    symbol: stock.symbol,
                                    price: stock.price,
                                    change: stock.change,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(double holding, double invested, double available) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [
          Color(0xff0F2027),
          Color(0xff203A43),
          Color(0xff2C5364),
        ]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Portfolio', style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 8),
          Text('€${holding.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('+9.77%', style: TextStyle(color: Colors.greenAccent)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Invested: €${invested.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
              Text('Available: €${available.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white)),
            ],
          )
        ],
      ),
    );
  }
}
