import 'package:flutter/material.dart';

import '../models/stock_model.dart';

class StockDetailScreen extends StatelessWidget {
  final ValueNotifier<StockModel> stockNotifier;

  const StockDetailScreen({super.key, required this.stockNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Details')),
      body: Center(
        // Surgical rebuilds for the detail view
        child: ValueListenableBuilder<StockModel>(
          valueListenable: stockNotifier,
          builder: (context, stock, _) {
            final isPositive = stock.netChange >= 0;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stock.symbol,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '\Rs ${stock.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 64),
                ),
                const SizedBox(height: 8),
                Text(
                  '${isPositive ? '+' : ''}${stock.netChange.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
