// import 'dart:async';
// import 'package:flutter/material.dart';
// import '../../data/models/stock.dart';
// import '../../data/services/stock_data_source.dart';
//
// class StockDetailScreen extends StatefulWidget {
//   final Stock stock;
//   final StockDataSource service;
//
//   const StockDetailScreen({
//     super.key,
//     required this.stock,
//     required this.service,
//
//   });
//   @override
//   State<StockDetailScreen> createState() =>
//       _StockDetailScreenState();
//
// }
// class _StockDetailScreenState
//     extends State<StockDetailScreen> {
//
//   late Stock currentStock;
//   StreamSubscription<Stock>? subscription;
//   @override
//   void initState() {
//     super.initState();
//     currentStock = widget.stock;
//     // Listen to only this stock updates
//     subscription =
//         widget.service
//             .getStockStream(widget.stock.symbol)
//             .listen(
//
//               (updatedStock) {
//             setState(() {
//               currentStock = updatedStock;
//             });
//           },
//         );
//   }
//   @override
//   void dispose() {
//     subscription?.cancel();
//     super.dispose();
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     final bool isUp =
//         currentStock.change >= 0;
//     return Scaffold(
//       appBar: AppBar(
//
//         title: Text(
//           currentStock.symbol,
//
//         ),
//
//         centerTitle: true,
//
//       ),
//
//       body: SizedBox.expand(
//         child: Column(
//           mainAxisAlignment:
//           MainAxisAlignment.center,
//           crossAxisAlignment:
//           CrossAxisAlignment.center,
//
//           children: [
//             Text(
//
//               currentStock.name,
//               textAlign:
//               TextAlign.center,
//               style:
//               const TextStyle(
//                 fontSize: 24,
//                 fontWeight:
//                 FontWeight.bold,
//
//
//               ),
//
//             ),
//             const SizedBox(
//               height: 25,
//
//             ),
//             Text(
//               currentStock.currentPrice
//                   .toStringAsFixed(2),
//               style:
//               const TextStyle(
//                 fontSize: 42,
//                 fontWeight:
//                 FontWeight.bold,
//               ),
//
//             ),
//
//             const SizedBox(
//               height: 15,
//             ),
//
//             Text(
//               "${isUp ? '+' : ''}"
//                   "${currentStock.change.toStringAsFixed(2)}",
//               style:
//               TextStyle(
//                 fontSize: 24,
//                 fontWeight:
//                 FontWeight.bold,
//                 color:
//                 isUp
//                     ? Colors.green
//                     : Colors.red,
//               ),
//             ),
//
//             const SizedBox(
//               height: 20,
//
//             ),
//             Text(
//               "Live Updating",
//               style:
//               TextStyle(
//                 color:
//                 Colors.grey[600],
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/stock.dart';
import '../providers/stock_provider.dart';
import '../../domain/state/stock_state.dart';

class StockDetailScreen extends ConsumerWidget {
  final Stock stock;
  const StockDetailScreen({
    super.key,
    required this.stock,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);
    Stock currentStock = stock;

    if (stockState is StockLoaded) {
      currentStock = stockState.stocks.firstWhere(
            (item) => item.symbol == stock.symbol,
        orElse: () => stock,
      );
    }                               // Learn this loop
    final bool isUp = currentStock.change >= 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentStock.symbol,
        ),
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          crossAxisAlignment:
          CrossAxisAlignment.center,
          children: [
            Text(
              currentStock.name,
              textAlign:
              TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight:
                FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(

              currentStock.currentPrice
                  .toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 42,
                fontWeight:
                FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "${isUp ? '+' : ''}"
                  "${currentStock.change.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 24,
                fontWeight:
                FontWeight.bold,
                color: isUp
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Live Updating",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}