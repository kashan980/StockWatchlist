import 'dart:async';
import 'dart:math';
import '../models/stock.dart';
import 'package:flutter/material.dart';
class MockStockService {
  final Random random = Random();
  // Stores current stock values
  final Map<String, Stock> stocks = {};
  // Separate stream for every stock
  final Map<String, StreamController<Stock>> controllers = {};
  Timer? timer;
  MockStockService(List<Stock> initialStocks) {
    for (var stock in initialStocks) {
      // Store stock
      stocks[stock.symbol] = stock;
      // Create individual stream for this stock
      controllers[stock.symbol] =
      StreamController<Stock>.broadcast();
    }
  }
  // Get specific stock stream
  Stream<Stock> getStockStream(String symbol) {
    return controllers[symbol]!.stream;

  }
  // Start live feed
  void start() {
    timer = Timer.periodic(
      const Duration(seconds: 2),

          (_) {
        updateRandomStock();
      },
    );

  }
  // Update all stocks every 2 seconds
  void updateRandomStock() {
    for (var symbol in stocks.keys) {
      final oldStock =
      stocks[symbol]!;
      // Random movement between -2 and +2
      final movement =
          (random.nextDouble() * 4) - 2;
      final newPrice =
          oldStock.currentPrice + movement;
      final newChange =
          newPrice - oldStock.previousClose;



      final newChangePercentage =
          (newChange / oldStock.previousClose) * 100;

      final updatedStock =
      oldStock.copyWith(
        currentPrice: newPrice,
        change: newChange,
        changePercentage:
        newChangePercentage,

      );
      // Update stored value
      stocks[symbol] = updatedStock;
      // Send update only to this stock stream

      controllers[symbol]!
          .add(updatedStock);
      // Debug checking

      debugPrint(
        '$symbol updated: ${updatedStock.currentPrice}',
      );

    }
  }
  // Clean memory

  void dispose() {
    timer?.cancel();
    for (var controller in controllers.values) {
      controller.close();
    }
  }
}