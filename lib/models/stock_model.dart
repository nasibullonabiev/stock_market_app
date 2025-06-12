class StockModel {
  final String name;
  final String symbol;
  final double price;
  final double change;
  final bool isGainer;
  final String logoUrl;

  StockModel({
    required this.name,
    required this.symbol,
    required this.price,
    required this.change,
    required this.isGainer,
    required this.logoUrl,
  });
}

final List<StockModel> dummyStocks = [
  StockModel(
    name: 'Apple',
    symbol: 'AAPL',
    price: 189.20,
    change: 1.53,
    isGainer: true,
    logoUrl: 'https://logo.clearbit.com/apple.com',
  ),
  StockModel(
    name: 'Tesla',
    symbol: 'TSLA',
    price: 256.74,
    change: -2.13,
    isGainer: false,
    logoUrl: 'https://logo.clearbit.com/tesla.com',
  ),
  StockModel(
    name: 'Amazon',
    symbol: 'AMZN',
    price: 133.44,
    change: 3.12,
    isGainer: true,
    logoUrl: 'https://logo.clearbit.com/amazon.com',
  ),
  StockModel(
    name: 'Google',
    symbol: 'GOOGL',
    price: 125.76,
    change: -1.88,
    isGainer: false,
    logoUrl: 'https://logo.clearbit.com/google.com',
  ),
  StockModel(
    name: 'Netflix',
    symbol: 'NFLX',
    price: 448.89,
    change: 2.41,
    isGainer: true,
    logoUrl: 'https://logo.clearbit.com/netflix.com',
  ),
  StockModel(
    name: 'Microsoft',
    symbol: 'MSFT',
    price: 321.58,
    change: 0.93,
    isGainer: true,
    logoUrl: 'https://logo.clearbit.com/microsoft.com',
  ),
  StockModel(
    name: 'Meta',
    symbol: 'META',
    price: 284.12,
    change: -0.74,
    isGainer: false,
    logoUrl: 'https://logo.clearbit.com/meta.com',
  ),
  StockModel(
    name: 'Nvidia',
    symbol: 'NVDA',
    price: 730.45,
    change: 5.67,
    isGainer: true,
    logoUrl: 'https://logo.clearbit.com/nvidia.com',
  ),
  StockModel(
    name: 'Intel',
    symbol: 'INTC',
    price: 35.21,
    change: -1.05,
    isGainer: false,
    logoUrl: 'https://logo.clearbit.com/intel.com',
  ),
  StockModel(
    name: 'Adobe',
    symbol: 'ADBE',
    price: 612.34,
    change: 4.25,
    isGainer: true,
    logoUrl: 'https://logo.clearbit.com/adobe.com',
  ),
];
