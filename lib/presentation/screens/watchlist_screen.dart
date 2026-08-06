// import 'package:flutter/material.dart';
// import '../../data/models/stock.dart';
// import '../../data/services/api_service.dart';
// import '../../data/services/stock_data_source.dart';
// import '../widgets/stock_price_widget.dart';
//
// class WatchlistScreen extends StatefulWidget {
//   const WatchlistScreen({super.key});
//
//   @override
//   State<WatchlistScreen> createState() => _WatchlistScreenState();
// }
//
// class _WatchlistScreenState extends State<WatchlistScreen> {
//   final ApiService apiService = ApiService();
//
//   List<Stock> stocks = [];
//
//   StockDataSource? service;
//
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//
//     loadStocks();
//   }
//
//   Future<void> loadStocks() async {
//     try {
//
//       final result = await apiService.fetchStocks();
//
//       service = StockDataSource(result);
//
//       service!.start();
//
//       setState(() {
//         stocks = result;
//         isLoading = false;
//       });
//
//     } catch (e) {
//       debugPrint("Error loading stocks: $e");
//
//       setState(() {
//         isLoading = false;
//       });
//
//     }
//   }
//
//   @override
//   void dispose() {
//     service?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Stock Watchlist")),
//
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: stocks.length,
//
//               itemBuilder: (context, index) {
//                 final stock = stocks[index];
//
//                 return StockPriceWidget(stock: stock, service: service!);
//               },
//             ),
//     );
//   }
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
        ),


        body: stockState is StockLoading

            ? const Center(
          child: CircularProgressIndicator(),
        )


            : stockState is StockError

            ? Center(
          child: Text(
            stockState.message,
          ),
        )


            : stockState is StockLoaded

            ? ListView.builder(

          itemCount: stockState.stocks.length,


          itemBuilder: (context, index) {

            final stock =
            stockState.stocks[index];


            return StockPriceWidget(
              stock: stock,
            );

          },

        )


            : const SizedBox(),);

    }

}