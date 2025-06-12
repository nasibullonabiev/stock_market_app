import 'package:flutter/material.dart';
import '../../models/stock_model.dart';
import '../../widgets/stock_tile.dart';
import '../stock/stock_detail_screen.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gainerStocks = dummyStocks.where((stock) => stock.isGainer).toList();
    final loserStocks = dummyStocks.where((stock) => !stock.isGainer).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.pink,
          labelColor: Colors.pink,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Gainer'),
            Tab(text: 'Loser'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStockList(gainerStocks),
          _buildStockList(loserStocks),
        ],
      ),
    );
  }

  Widget _buildStockList(List<StockModel> stocks) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: stocks.length,
      itemBuilder: (context, index) {
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
                  price: stock.price,
                  change: stock.change,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
