import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/stock_cubit.dart';
import '../cubit/stock_state.dart';
import '../widgets/stock_row.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Watchlist'),
        actions: [
          // Day 2 Requirement: Pause / Resume Toggle Button
          BlocBuilder<StockCubit, StockState>(
            builder: (context, state) {
              if (state is StockLoaded) {
                return IconButton(
                  icon: Icon(
                    state.isPaused ? Icons.play_arrow : Icons.pause,
                    color: state.isPaused ? Colors.green : Colors.orange,
                  ),
                  tooltip: state.isPaused ? 'Resume Feed' : 'Pause Feed',
                  onPressed: () {
                    context.read<StockCubit>().togglePause();
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Day 2 Requirement: Search / Filter Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search ticker symbol...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (query) {
                context.read<StockCubit>().updateSearch(query);
              },
            ),
          ),

          // Watchlist Stream Builder
          Expanded(
            child: BlocBuilder<StockCubit, StockState>(
              builder: (context, state) {
                if (state is StockLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is StockError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                }

                if (state is StockLoaded) {
                  final stocks = state.filteredStocks;

                  if (stocks.isEmpty) {
                    return const Center(
                      child: Text('No stocks match your search.'),
                    );
                  }

                  return ListView.separated(
                    itemCount: stocks.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final stock = stocks[index];
                      return StockRow(
                        key: ValueKey(stock.symbol),
                        symbol: stock.symbol,
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
