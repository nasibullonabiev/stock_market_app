import 'package:flutter/material.dart';
import '../models/news_model.dart';

class NewsTile extends StatelessWidget {
  final NewsModel news;

  const NewsTile({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  news.subtitle,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  '${news.source} • ${news.timeAgo}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              news.imageUrl,
              width: 90,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
