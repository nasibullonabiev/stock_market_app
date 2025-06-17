import 'package:flutter/material.dart';
import '../../models/stock_model.dart';
import '../../services/stock_api_service.dart';
import '../../widgets/stock_tile.dart';
import '../stock/stock_detail_screen.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final StockApiService _stockApiService = StockApiService();
  late Future<List<StockModel>> _stockFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _stockFuture = _stockApiService.fetchStocks(); // uses cached by default
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<StockModel>>(
        future: _stockFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No stock data available.'));
          }

          final stocks = snapshot.data!;
          final gainers = stocks.where((s) => s.isGainer).toList();
          final losers = stocks.where((s) => !s.isGainer).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildStockList(gainers),
              _buildStockList(losers),
            ],
          );
        },
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
  }
}
