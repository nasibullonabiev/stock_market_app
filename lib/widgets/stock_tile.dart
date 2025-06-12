import 'package:flutter/material.dart';

class StockTile extends StatelessWidget {
  final String name;
  final String symbol;
  final double price;
  final double change;
  final String logoUrl;
  final VoidCallback onTap;

  const StockTile({
    super.key,
    required this.name,
    required this.symbol,
    required this.price,
    required this.change,
    required this.logoUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPositive = change >= 0;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  logoUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(symbol, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '€${price.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}%',
                    style: TextStyle(color: isPositive ? Colors.green : Colors.red),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
