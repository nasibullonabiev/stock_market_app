import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import '../models/stock_model.dart';
import '../models/historical_price.dart';

class StockApiService {
  static const _apiKey = 'a014e1a6d5742c43e3646fdcca85bf2e';
  static const _baseUrl = 'https://api.marketstack.com/v1';
  static const _symbols = [
    'AAPL', 'TSLA', 'AMZN', 'GOOGL', 'NFLX',
    'MSFT', 'META', 'NVDA', 'INTC', 'UBER',
  ];

  final String _cacheKey = 'cachedStocks';

  Future<List<StockModel>> fetchStocks({bool forceRefresh = false}) async {
    final box = await Hive.openBox('stockBox');

    if (!forceRefresh && box.containsKey(_cacheKey)) {
      final cachedJson = box.get(_cacheKey) as List<dynamic>;
      return cachedJson
          .map((json) => StockModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    }

    try {
      final url = Uri.parse(
        '$_baseUrl/eod/latest?access_key=$_apiKey&symbols=${_symbols.join(",")}',
      );

      final res = await http.get(url);
      if (res.statusCode != 200) throw Exception('Failed to fetch stock data');

      final data = json.decode(res.body);
      final List<dynamic> results = data['data'];

      final stocks = results.map((item) {
        final symbol = item['symbol'];
        final price = double.tryParse(item['close']?.toString() ?? '0') ?? 0.0;
        final open = double.tryParse(item['open']?.toString() ?? '0') ?? 0.0;
        final change = price - open;
        final isGainer = change >= 0;

        return StockModel(
          name: symbolToName(symbol),
          symbol: symbol,
          price: price,
          change: change,
          isGainer: isGainer,
          logoUrl: 'https://logo.clearbit.com/${symbolToDomain(symbol)}',
        );
      }).toList();

      await box.put(_cacheKey, stocks.map((s) => s.toJson()).toList());
      return stocks;
    } catch (e) {
      print('Stock API Error: $e');
      if (box.containsKey(_cacheKey)) {
        final fallbackJson = box.get(_cacheKey) as List<dynamic>;
        return fallbackJson
            .map((json) => StockModel.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      }
      return [];
    }
  }

  Future<List<HistoricalPrice>> fetchHistoricalPrices(String symbol) async {
    final url = Uri.parse(
      '$_baseUrl/eod?access_key=$_apiKey&symbols=$symbol&limit=30',
    );

    try {
      final res = await http.get(url);
      if (res.statusCode != 200) throw Exception('Failed to fetch historical data');

      final data = json.decode(res.body);
      final List<dynamic> results = data['data'];

      return results.map((e) => HistoricalPrice.fromJson(e)).toList().reversed.toList();
    } catch (e) {
      print('Chart API Error: $e');
      return [];
    }
  }

  String symbolToName(String symbol) {
    switch (symbol) {
      case 'AAPL': return 'Apple';
      case 'TSLA': return 'Tesla';
      case 'AMZN': return 'Amazon';
      case 'GOOGL': return 'Google';
      case 'NFLX': return 'Netflix';
      case 'MSFT': return 'Microsoft';
      case 'META': return 'Meta';
      case 'NVDA': return 'Nvidia';
      case 'INTC': return 'Intel';
      case 'UBER': return 'Uber';
      default: return symbol;
    }
  }

  String symbolToDomain(String symbol) {
    switch (symbol) {
      case 'AAPL': return 'apple.com';
      case 'TSLA': return 'tesla.com';
      case 'AMZN': return 'amazon.com';
      case 'GOOGL': return 'google.com';
      case 'NFLX': return 'netflix.com';
      case 'MSFT': return 'microsoft.com';
      case 'META': return 'meta.com';
      case 'NVDA': return 'nvidia.com';
      case 'INTC': return 'intel.com';
      case 'UBER': return 'uber.com';
      default: return '$symbol.com';
    }
  }
}
