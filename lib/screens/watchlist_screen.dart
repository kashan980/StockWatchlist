import 'package:flutter/material.dart';
import '../models/stock.dart';
import '../services/api_service.dart';
import '../services/stock_data_source.dart';
import '../widgets/stock_price_widget.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final ApiService apiService = ApiService();

  List<Stock> stocks = [];

  StockDataSource? service;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadStocks();
  }

  Future<void> loadStocks() async {
    try {

      final result = await apiService.fetchStocks();

      service = StockDataSource(result);

      service!.start();

      setState(() {
        stocks = result;
        isLoading = false;
      });

    } catch (e) {
      debugPrint("Error loading stocks: $e");

      setState(() {
        isLoading = false;
      });

    }
  }

  @override
  void dispose() {
    service?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stock Watchlist")),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: stocks.length,

              itemBuilder: (context, index) {
                final stock = stocks[index];

                return StockPriceWidget(stock: stock, service: service!);
              },
            ),
    );
  }
}
