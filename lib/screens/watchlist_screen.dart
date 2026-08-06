import 'package:flutter/material.dart';

import '../services/stock_service.dart';
import '../widgets/stock_row.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final StockService _stockService = StockService();

  @override
  void initState() {
    super.initState();
    _stockService.initializeAndFetch();
  }

  @override
  void dispose() {
    _stockService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Market Watch')),
      body: ValueListenableBuilder<bool>(
        valueListenable: _stockService.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.separated(
            itemCount: _stockService.stockNotifiers.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final symbol = _stockService.stockNotifiers.keys.elementAt(index);
              final notifier = _stockService.stockNotifiers[symbol]!;
              return StockRow(stockNotifier: notifier);
            },
          );
        },
      ),
    );
  }
}
