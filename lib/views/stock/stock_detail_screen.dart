import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/stock_api_service.dart';
import '../../models/historical_price.dart';

class StockDetailScreen extends StatefulWidget {
  final String name;
  final double price;
  final double change;
  final String symbol;

  const StockDetailScreen({
    super.key,
    required this.name,
    required this.price,
    required this.change,
    required this.symbol,
  });

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  final StockApiService _stockApiService = StockApiService();
  List<FlSpot> chartSpots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    final data = await _stockApiService.fetchHistoricalPrices(widget.symbol);
    if (data.isEmpty) {
      setState(() {
        chartSpots = [];
        isLoading = false;
      });
      return;
    }

    final spots = data.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final price = entry.value.close;
      return FlSpot(index, price);
    }).toList();

    setState(() {
      chartSpots = spots;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isPositive = widget.change >= 0;
    final Color changeColor = isPositive ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('€${widget.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text('${isPositive ? '+' : ''}${widget.change.toStringAsFixed(2)}%',
                style: TextStyle(fontSize: 18, color: changeColor)),
            const SizedBox(height: 24),

            SizedBox(
              height: 200,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : chartSpots.isEmpty
                  ? const Center(child: Text("No chart data"))
                  : LineChart(
                LineChartData(
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      spots: chartSpots,
                      color: Colors.pink,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['1H', '24H', '1W', '1M', '1Y', 'All'].map((label) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: OutlinedButton(
                      onPressed: () {}, // Future: hook real period filtering
                      child: Text(label),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            Text('${widget.name}\nHolding: 0.00', style: const TextStyle(fontSize: 16)),
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
