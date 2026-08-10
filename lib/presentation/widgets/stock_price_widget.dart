// import 'dart:async';
// import 'package:flutter/material.dart';
// import '../../data/models/stock.dart';
// import '../../data/services/stock_data_source.dart';
// import '../screens/stock_detailed_screen.dart';
//
// class StockPriceWidget extends StatefulWidget {
// final Stock stock;
// final StockDataSource service;
//
// const StockPriceWidget({
// super.key,
// required this.stock,
// required this.service,
// });
//
// @override
// State createState() => _StockPriceWidgetState();
// }
//
// class StockPriceWidgetState extends State {
// late Stock currentStock;
//
// StreamSubscription*? subscription;*
//
// Color? highlightColor;
//
// @override
// void initState() {
// super.initState();
//
// currentStock = widget.stock;
//
// subscription = widget.service.getStockStream(widget.stock.symbol).listen((
// updatedStock,
// ) {
// final bool priceIncreased =
// updatedStock.currentPrice > currentStock.currentPrice;
//
// setState(() {
// currentStock = updatedStock;
//
// highlightColor = priceIncreased
// ? Colors.green.withValues(alpha: 0.25)
// : Colors.red.withValues(alpha: 0.25);
// });
//
// Future.delayed(const Duration(milliseconds: 600), () {
// if (mounted) {
// setState(() {
// highlightColor = null;
// });
// }
// });
// });
// }
//
// @override
// void dispose() {
// subscription?.cancel();
//
// super.dispose();
// }
//
// @override
// Widget build(BuildContext context) {
// final bool isUp = currentStock.change >= 0;
//
// return InkWell(
// borderRadius: BorderRadius.circular(12),
//
// onTap: () {
// Navigator.push(
// context,
//
// MaterialPageRoute(
// builder: () =>
// StockDetailScreen(stock: currentStock, service: widget.service),
// ),
// );
// },
//
// child: AnimatedContainer(
// duration: const Duration(milliseconds: 500),
//
// margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//
// decoration: BoxDecoration(
// color: highlightColor ?? Colors.transparent,
//
// borderRadius: BorderRadius.circular(12),
// ),
//
// child: Card(
// child: ListTile(
// title: Text(
// currentStock.symbol,
//
// style: const TextStyle(fontWeight: FontWeight.bold),
// ),
//
// subtitle: Text(currentStock.name),
//
// trailing: Column(
// mainAxisAlignment: MainAxisAlignment.center,
//
// crossAxisAlignment: CrossAxisAlignment.end,
//
// children: [
// Text(
// currentStock.currentPrice.toStringAsFixed(2),
//
// style: const TextStyle(fontWeight: FontWeight.bold),
// ),
//
// Text(
// "${isUp ? '+' : ''}"
// "${currentStock.change.toStringAsFixed(2)}",
//
// style: TextStyle(
// color: isUp ? Colors.green : Colors.red,
//
// fontWeight: FontWeight.bold,
// ),
// ),
// ],
// ),
// ),
// ),
// ),
// );
// }
// }

import 'package:flutter/material.dart';
import '../../data/models/stock.dart';
import '../screens/stock_detailed_screen.dart';

class StockPriceWidget extends StatelessWidget {

  final Stock stock;
  const StockPriceWidget({
    super.key,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {

    final bool isUp = stock.change >= 0;
    return InkWell(

      borderRadius: BorderRadius.circular(12),
      onTap: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StockDetailScreen(
              stock: stock,
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        //color: highlightColor,
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: Card(
          child: ListTile(
            title: Text(
              stock.symbol,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),

            ),
            subtitle: Text(
              stock.name,
            ),
            trailing: Column(

              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.end,
              children: [
                Text(

                  stock.currentPrice.toStringAsFixed(2),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),


                Text(

                  "${isUp ? '+' : ''}"
                      "${stock.change.toStringAsFixed(2)}",
                  style: TextStyle(

                    color: isUp
                        ? Colors.green
                        : Colors.red,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );


  }
}

// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../data/models/stock.dart';
// import '../providers/stock_provider.dart';
// import '../screens/stock_detailed_screen.dart';
//
// class StockPriceWidget extends ConsumerStatefulWidget {
//   final Stock stock;
//
//   const StockPriceWidget({
//     super.key,
//     required this.stock,
//   });
//
//   @override
//   ConsumerState<StockPriceWidget> createState() {
//     return _StockPriceWidgetState();
//   }
// }
//
// class _StockPriceWidgetState
//     extends ConsumerState<StockPriceWidget> {
//
//   Color? highlightColor;
//
//   double? previousPrice;
//
//   Timer? highlightTimer;
//
//   @override
//   void dispose() {
//     highlightTimer?.cancel();
//     super.dispose();
//   }
//
//   void _showHighlight(bool priceIncreased) {
//
//     highlightTimer?.cancel();
//
//     setState(() {
//       highlightColor = priceIncreased
//           ? Colors.green.withValues(alpha: 0.25)
//           : Colors.red.withValues(alpha: 0.25);
//     });
//
//     highlightTimer = Timer(
//       const Duration(milliseconds: 600),
//           () {
//         if (!mounted) return;
//
//         setState(() {
//           highlightColor = null;
//         });
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     // ========================================================
//     // WATCH ONLY THIS STOCK
//     // ========================================================
//
//     final stockAsync = ref.watch(
//       stockStreamProvider(widget.stock.symbol),
//     );
//
//     // ========================================================
//     // CURRENT STOCK
//     // ========================================================
//     //
//     // If the stream hasn't emitted yet, use the initial
//     // stock passed from WatchlistScreen.
//     //
//
//     final Stock currentStock = stockAsync.value ?? widget.stock;
//
//     // ========================================================
//     // DETECT PRICE CHANGE
//     // ========================================================
//
//     if (stockAsync.hasValue) {
//
//       final updatedStock = stockAsync.value!;
//
//       if (previousPrice != null &&
//           updatedStock.currentPrice != previousPrice) {
//
//         final priceIncreased =
//             updatedStock.currentPrice > previousPrice!;
//
//         // Schedule after build.
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//
//           if (!mounted) return;
//
//           _showHighlight(priceIncreased);
//         });
//       }
//
//       previousPrice = updatedStock.currentPrice;
//     }
//
//     // ========================================================
//     // UP / DOWN
//     // ========================================================
//
//     final bool isUp = currentStock.change >= 0;
//
//     // ========================================================
//     // UI
//     // ========================================================
//
//     return InkWell(
//       borderRadius: BorderRadius.circular(12),
//
//       onTap: () {
//
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) {
//               return StockDetailScreen(
//                 stock: currentStock,
//               );
//             },
//           ),
//         );
//       },
//
//       child: AnimatedContainer(
//         duration: const Duration(
//           milliseconds: 500,
//         ),
//
//         margin: const EdgeInsets.symmetric(
//           horizontal: 8,
//           vertical: 4,
//         ),
//
//         decoration: BoxDecoration(
//           color: highlightColor ??
//               Colors.transparent,
//
//           borderRadius: BorderRadius.circular(12),
//         ),
//
//         child: Card(
//           child: ListTile(
//
//             // =================================================
//             // SYMBOL
//             // =================================================
//
//             title: Text(
//               currentStock.symbol,
//
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//
//             // =================================================
//             // NAME
//             // =================================================
//
//             subtitle: Text(
//               currentStock.name,
//             ),
//
//             // =================================================
//             // PRICE + CHANGE
//             // =================================================
//
//             trailing: Column(
//               mainAxisAlignment:
//               MainAxisAlignment.center,
//
//               crossAxisAlignment:
//               CrossAxisAlignment.end,
//
//               children: [
//
//                 // Current price
//                 Text(
//                   currentStock.currentPrice
//                       .toStringAsFixed(2),
//
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//
//                 // Change
//                 Text(
//                   "${isUp ? '+' : ''}"
//                       "${currentStock.change.toStringAsFixed(2)}",
//
//                   style: TextStyle(
//                     color: isUp
//                         ? Colors.green
//                         : Colors.red,
//
//                     fontWeight:
//                     FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }