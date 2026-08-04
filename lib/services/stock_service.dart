import 'dart:async';
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
      final response = await _dio.get(
        'https://gist.githubusercontent.com/juni12891226/937ac4583eb7407416830652df1c9fbc/raw/c7e96c1691ed15dd9ded27018cd8742ba5d1a0f6/gistfile1.txt',
      );

      _populateInitialData();
    } catch (e) {
      _populateInitialData();
    }

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
