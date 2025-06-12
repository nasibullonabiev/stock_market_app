import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/dummy_news.dart';
import '../../widgets/stock_tile.dart';
import '../../widgets/news_tile.dart';
import '../../models/stock_model.dart';
import '../stock/stock_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  Future<String> _fetchUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return 'User';
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc['nickname'] ?? 'User';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _fetchUserName(),
      builder: (context, snapshot) {
        final nickname = snapshot.data ?? 'User';

        return Scaffold(
          appBar: AppBar(title: const Text('Home')),
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
                      Text('Welcome $nickname,',
                          style: const TextStyle(color: Colors.white, fontSize: 16)),
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
                ),
                const SizedBox(height: 24),
                const Text('Stocks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: dummyStocks.length + dummyNews.length + 1,
                    itemBuilder: (context, index) {
                      if (index < dummyStocks.length) {
                        final stock = dummyStocks[index];
                        return StockTile(
                          name: stock.name,
                          symbol: stock.symbol,
                          price: stock.price,
                          change: stock.change,
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
                          }, logoUrl: stock.logoUrl,
                        );
                      } else if (index == dummyStocks.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text('Top Stories',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        );
                      } else {
                        final newsIndex = index - dummyStocks.length - 1;
                        final news = dummyNews[newsIndex];
                        return NewsTile(news: news);
                      }
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
