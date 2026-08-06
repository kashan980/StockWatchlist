import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/stock_cubit.dart';
import '../cubit/stock_state.dart';
import '../models/stock_model.dart';

class StockDetailScreen extends StatelessWidget {
  final String symbol;

  // Now it strictly expects a String symbol instead of a ValueNotifier!
  const StockDetailScreen({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$symbol Live Details')),
      // BlocSelector ensures this screen ONLY rebuilds when THIS stock updates
      body: BlocSelector<StockCubit, StockState, StockModel?>(
        selector: (state) {
          if (state is StockLoaded) {
            return state.stocks[symbol];
          }
          return null;
        },
        builder: (context, stock) {
          if (stock == null) {
            return const Center(child: Text('Stock data unavailable.'));
          }

          final isPositive = stock.netChange >= 0;

          return Center(
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
                const SizedBox(height: 20),
                Text(
                  'Rs ${stock.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${isPositive ? "+" : ""}${stock.netChange.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
