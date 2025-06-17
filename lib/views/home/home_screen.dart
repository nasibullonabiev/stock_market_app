import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/dummy_news.dart';
import '../../models/stock_model.dart';
import '../../services/stock_api_service.dart';
import '../../widgets/news_tile.dart';
import '../../widgets/stock_tile.dart';
import '../stock/stock_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StockApiService _stockApiService = StockApiService();
  late Future<List<StockModel>> _stockFuture;
  String _nickname = 'User';

  @override
  void initState() {
    super.initState();
    _loadStocks();
    _fetchUserName();
  }

  void _loadStocks({bool force = false}) {
    setState(() {
      _stockFuture = _stockApiService.fetchStocks(forceRefresh: force);
    });
  }

  Future<void> _fetchUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (mounted) {
      setState(() {
        _nickname = doc['nickname'] ?? 'User';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadStocks(force: true), // force refresh
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 24),
            const Text('Stocks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<StockModel>>(
                future: _stockFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Failed to load stocks'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No stock data available'));
                  }

                  final stocks = snapshot.data!;
                  final totalItems = stocks.length + dummyNews.length + 1;

                  return ListView.builder(
                    itemCount: totalItems,
                    itemBuilder: (context, index) {
                      if (index < stocks.length) {
                        final stock = stocks[index];
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
                                  symbol: stock.symbol, // ✅ for future use
                                  price: stock.price,
                                  change: stock.change,
                                ),
                              ),
                            );
                          },
                        );
                      } else if (index == stocks.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text('Top Stories',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        );
                      } else {
                        final newsIndex = index - stocks.length - 1;
                        final news = dummyNews[newsIndex];
                        return NewsTile(news: news);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade800,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome $_nickname,', style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 8),
          const Text('Make your first Investment today',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text('Invest Today', style: TextStyle(color: Colors.pink)),
          )
        ],
      ),
    );
  }
}
