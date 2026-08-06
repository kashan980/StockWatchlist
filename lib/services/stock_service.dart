import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/stock_model.dart';

class StockService {
  final Dio _dio = Dio();
  Timer? _liveFeedTimer;

  final Map<String, ValueNotifier<StockModel>> stockNotifiers = {};
  final ValueNotifier<bool> isLoading = ValueNotifier(true);

  Future<void> initializeAndFetch() async {
    isLoading.value = true;
    try {
      // 1. Actually fetching the data from the API
      final response = await _dio.get(
        'https://gist.githubusercontent.com/juni12891226/937ac4583eb7407416830652df1c9fbc/raw/c7e96c1691ed15dd9ded27018cd8742ba5d1a0f6/gistfile1.txt',
      );

      // 2. Parsing the text file into a JSON list
      List<dynamic> parsedData;
      if (response.data is String) {
        parsedData = jsonDecode(response.data);
      } else {
        parsedData = response.data;
      }

      // 3. Building the stocks DIRECTLY from the API data
      for (var item in parsedData) {
        final stock = StockModel.fromJson(item);
        stockNotifiers[stock.symbol] = ValueNotifier(stock);
      }
    } catch (e) {
      // 4. If the internet is off, fall back to offline dummy data
      _populateInitialData();
    }

    _startLiveFeed();
    isLoading.value = false;
  }

  void _populateInitialData() {
    // Now the fallback matches a full 10-stock market!
    final tickers = [
      'AGP', 'PSO', 'SAZGAAR', 'MLCF', 'UBL',
      'SYS', 'TRG', 'HUBC', 'ENGRO', 'LUCK', // Added 5 more
    ];

    for (var ticker in tickers) {
      final initialPrice = 50.0 + Random().nextInt(100);

      stockNotifiers[ticker] = ValueNotifier(
        StockModel(
          symbol: ticker,
          price: initialPrice,
          netChange: 0.0,
          openPrice: initialPrice,
          marketOpen: '09:30 AM',
          marketClose: '03:30 PM',
        ),
      );
    }
  }

  void _startLiveFeed() {
    _liveFeedTimer?.cancel();

    _liveFeedTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (stockNotifiers.isEmpty) return;

      final random = Random();
      final keys = stockNotifiers.keys.toList();

      final randomTicker = keys[random.nextInt(keys.length)];
      final notifier = stockNotifiers[randomTicker]!;
      final oldStock = notifier.value;

      final change = (random.nextDouble() * 4) - 2;
      final newPrice = oldStock.price + change;

      // Safe rebuild of the StockModel including the new required variables
      notifier.value = StockModel(
        symbol: oldStock.symbol,
        price: newPrice,
        netChange: oldStock.netChange + change,
        openPrice: oldStock.openPrice, // Carries over the open price
        marketOpen: oldStock.marketOpen, // Carries over the open time
        marketClose: oldStock.marketClose, // Carries over the close time
      );
    });
  }

  void dispose() {
    _liveFeedTimer?.cancel();
    isLoading.dispose();
    for (var notifier in stockNotifiers.values) {
      notifier.dispose();
    }
    stockNotifiers.clear();
  }
}
