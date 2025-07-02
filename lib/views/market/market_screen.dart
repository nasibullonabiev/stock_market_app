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

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Added "All" tab
    _stockFuture = _stockApiService.fetchStocks();
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
            Tab(text: 'All'),
            Tab(text: 'Gainer'),
            Tab(text: 'Loser'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              cursorColor: Colors.pink,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search stocks...',
                hintStyle: const TextStyle(color: Colors.pink),
                prefixIcon: const Icon(Icons.search,color: Colors.pink,),
                filled: true,
                fillColor: Colors.grey.shade400,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,

                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<StockModel>>(
              future: _stockFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No stock data available.'));
                }

                final stocks = snapshot.data!;
                final allFiltered = _filterStocks(stocks);
                final gainersFiltered = _filterStocks(stocks.where((s) => s.isGainer).toList());
                final losersFiltered = _filterStocks(stocks.where((s) => !s.isGainer).toList());

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildStockList(allFiltered),
                    _buildStockList(gainersFiltered),
                    _buildStockList(losersFiltered),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<StockModel> _filterStocks(List<StockModel> stocks) {
    if (_searchQuery.isEmpty) return stocks;
    return stocks.where((s) {
      final query = _searchQuery.toLowerCase();
      return s.name.toLowerCase().contains(query) || s.symbol.toLowerCase().contains(query);
    }).toList();
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
