// import 'package:flutter/material.dart';
// import '../../data/models/stock.dart';
// import '../../data/services/api_service.dart';
// import '../../data/services/stock_data_source.dart';
// import '../widgets/stock_price_widget.dart';
//
// class WatchlistScreen extends StatefulWidget {
// const WatchlistScreen({super.key});
//
// @override
// State createState() => _WatchlistScreenState();
// }
//
// class _WatchlistScreenState extends State {
// final ApiService apiService = ApiService();
//
// List stocks = [];
//
// StockDataSource? service;
//
// bool isLoading = true;
//
// @override
// void initState() {
// super.initState();
//
// loadStocks();
// }
//
// Future loadStocks() async {
// try {
//
// final result = await apiService.fetchStocks();
//
// service = StockDataSource(result);
//
// service!.start();
//
// setState(() {
// stocks = result;
// isLoading = false;
// });
//
// } catch (e) {
// debugPrint("Error loading stocks: $e");
//
// setState(() {
// isLoading = false;
// });
//
// }
// }
//
// @override
// void dispose() {
// service?.dispose();
// super.dispose();
// }
//
// @override
// Widget build(BuildContext context) {
// return Scaffold(
// appBar: AppBar(title: const Text("Stock Watchlist")),
//
// body: isLoading
// ? const Center(child: CircularProgressIndicator())
// : ListView.builder(
// itemCount: stocks.length,
//
// itemBuilder: (context, index) {
// final stock = stocks[index];
//
// return StockPriceWidget(stock: stock, service: service!);
// },
// ),
// );
// }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/stock_provider.dart';
import '../widgets/stock_price_widget.dart';
import '../../domain/state/stock_state.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Watchlist"),

        actions: [
          IconButton(
            icon: const Icon(Icons.pause),

            onPressed: () {
              ref.read(stockProvider.notifier).pauseFeed();
            },
          ),

          IconButton(
            icon: const Icon(Icons.play_arrow),

            onPressed: () {
              ref.read(stockProvider.notifier).resumeFeed();
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),

            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search Symbol",

                border: OutlineInputBorder(),
              ),

              onChanged: (value) {
                ref.read(stockProvider.notifier).searchStocks(value);
              },
            ),
          ),

          Expanded(
            child: stockState is StockLoading
                ? const Center(child: CircularProgressIndicator())
                : stockState is StockError
                ? Center(child: Text(stockState.message))
                : stockState is StockLoaded
                ? ListView.builder(
              itemCount: stockState.stocks.length,

              itemBuilder: (context, index) {
                final stock = stockState.stocks[index];

                return StockPriceWidget(stock: stock);
              },
            )
                : const SizedBox(),
          ),
        ],
      ),
    );


  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../providers/stock_provider.dart';
// import '../widgets/stock_price_widget.dart';
// import '../../domain/state/stock_state.dart';
//
// class WatchlistScreen extends ConsumerStatefulWidget {
//   const WatchlistScreen({super.key});
//
//   @override
//   ConsumerState<WatchlistScreen> createState() {
//     return _WatchlistScreenState();
//   }
// }
//
// class _WatchlistScreenState
//     extends ConsumerState<WatchlistScreen> {
//
//   @override
//   Widget build(BuildContext context) {
//     final stockState = ref.watch(stockProvider);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Stock Watchlist"),
//
//         actions: [
//           // Pause
//           IconButton(
//             icon: const Icon(Icons.pause),
//             tooltip: "Pause feed",
//             onPressed: () {
//               ref
//                   .read(stockProvider.notifier)
//                   .pauseFeed();
//             },
//           ),
//
//           // Resume
//           IconButton(
//             icon: const Icon(Icons.play_arrow),
//             tooltip: "Resume feed",
//             onPressed: () {
//               ref
//                   .read(stockProvider.notifier)
//                   .resumeFeed();
//             },
//           ),
//         ],
//       ),
//
//       body: Column(
//         children: [
//
//           // ==================================================
//           // SEARCH
//           // ==================================================
//
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: TextField(
//               decoration: const InputDecoration(
//                 hintText: "Search Symbol",
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.search),
//               ),
//
//               onChanged: (value) {
//                 ref
//                     .read(stockProvider.notifier)
//                     .searchStocks(value);
//               },
//             ),
//           ),
//
//           // ==================================================
//           // STOCK LIST
//           // ==================================================
//
//           Expanded(
//             child: _buildStockList(stockState),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStockList(StockState stockState) {
//
//     // ======================================================
//     // LOADING
//     // ======================================================
//
//     if (stockState is StockLoading) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//
//     // ======================================================
//     // ERROR
//     // ======================================================
//
//     if (stockState is StockError) {
//       return Center(
//         child: Text(
//           stockState.message,
//         ),
//       );
//     }
//
//     // ======================================================
//     // LOADED
//     // ======================================================
//
//     if (stockState is StockLoaded) {
//
//       if (stockState.stocks.isEmpty) {
//         return const Center(
//           child: Text(
//             "No stocks found",
//           ),
//         );
//       }
//
//       return ListView.builder(
//         itemCount: stockState.stocks.length,
//
//         itemBuilder: (context, index) {
//
//           final stock = stockState.stocks[index];
//
//           return StockPriceWidget(
//             key: ValueKey(stock.symbol),
//             stock: stock,
//           );
//         },
//       );
//     }
//
//     return const SizedBox();
//   }
// }