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
      // 1. Fetch the data from the API
      final response = await _dio.get(
        'https://gist.githubusercontent.com/juni12891226/937ac4583eb7407416830652df1c9fbc/raw/c7e96c1691ed15dd9ded27018cd8742ba5d1a0f6/gistfile1.txt',
      );

      // 2. Convert the raw text into a JSON map
      final Map<String, dynamic> data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      // 3. Extract the 'stocks' list from the JSON
      final List<dynamic> stocksList = data['stocks'];

      // 4. Clear the hardcoded stuff and load ALL stocks from the API!
      stockNotifiers.clear();
      for (var item in stocksList) {
        final symbol = item['symbol'];
        final price = (item['current_price'] as num).toDouble();
        final netChange = (item['change'] as num).toDouble();

        // Create a Radio Tower for EVERY stock in the API using its real starting price
        stockNotifiers[symbol] = ValueNotifier(
          StockModel(symbol: symbol, price: price, netChange: netChange),
        );
      }
    } catch (e) {
      // 5. If the internet is disconnected, fallback to the 5 hardcoded stocks
      _populateInitialData();
    }

    // 6. Start the Timer to randomly fluctuate whichever stocks we just loaded!
    _startLiveFeed();
    isLoading.value = false;
  }

  void _populateInitialData() {
    final tickers = ['AGP', 'PSO', 'SAZGAAR', 'MLCF', 'UBL'];
    for (var ticker in tickers) {
      stockNotifiers[ticker] = ValueNotifier(
        StockModel(
          symbol: ticker,
          price: 50.0 + Random().nextInt(100),
          netChange: 0.0,
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

      notifier.value = oldStock.copyWith(
        price: newPrice,
        netChange: oldStock.netChange + change,
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
