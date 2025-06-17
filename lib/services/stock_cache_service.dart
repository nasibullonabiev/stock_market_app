// lib/services/stock_cache_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/stock_model.dart';

class StockCacheService {
  static const _boxName = 'stockCache';

  Future<void> saveStocks(List<StockModel> stocks) async {
    final box = await Hive.openBox(_boxName);
    final jsonList = stocks.map((s) => s.toJson()).toList();
    await box.put('stocks', jsonList);
    await box.put('lastUpdated', DateTime.now().toIso8601String());
  }

  Future<List<StockModel>> getCachedStocks() async {
    final box = await Hive.openBox(_boxName);
    final List<dynamic>? jsonList = box.get('stocks');
    if (jsonList == null) return [];
    return jsonList.map((json) => StockModel.fromJson(Map<String, dynamic>.from(json))).toList();
  }

  Future<DateTime?> getLastUpdatedTime() async {
    final box = await Hive.openBox(_boxName);
    final timestamp = box.get('lastUpdated');
    return timestamp != null ? DateTime.tryParse(timestamp) : null;
  }
}
