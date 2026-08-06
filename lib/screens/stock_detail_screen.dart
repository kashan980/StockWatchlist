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
        child: ValueListenableBuilder<StockModel>(
          valueListenable: stockNotifier,
          builder: (context, stock, _) {
            final isPositive = stock.netChange >= 0;
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
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
                    'Rs ${stock.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Percentage and Net Change Pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: (isPositive ? Colors.green : Colors.red)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${isPositive ? '+' : ''}${stock.netChange.toStringAsFixed(2)} (${isPositive ? '+' : ''}${stock.percentChange.toStringAsFixed(2)}%)',
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Divider(),
                  const SizedBox(height: 20),
                  // Market Open and Close Times Card
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMarketTimeTile(
                        'Market Open',
                        stock.marketOpen,
                        Icons.wb_sunny_outlined,
                      ),
                      _buildMarketTimeTile(
                        'Market Close',
                        stock.marketClose,
                        Icons.nights_stay_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMarketTimeTile(String label, String time, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[700]),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 2),
        Text(
          time,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
