import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/stock_repository.dart';
import '../models/stock_model.dart';
import 'stock_state.dart';

class StockCubit extends Cubit<StockState> {
  final StockRepository repository;
  Timer? _liveFeedTimer;

  // We start by telling the UI to show a Loading screen
  StockCubit(this.repository) : super(StockLoading());

  Future<void> loadStocks() async {
    try {
      final stocks = await repository.fetchStocks();
      // Once data is fetched, tell the UI it is Loaded!
      emit(StockLoaded(stocks: stocks));
      _startLiveFeed();
    } catch (e) {
      emit(const StockError("Failed to load market data."));
    }
  }

  // Day 2 Feature: Pause/Resume Toggle
  void togglePause() {
    if (state is StockLoaded) {
      final currentState = state as StockLoaded;
      emit(currentState.copyWith(isPaused: !currentState.isPaused));
    }
  }

  // Day 2 Feature: Search/Filter Bar
  void updateSearch(String query) {
    if (state is StockLoaded) {
      emit((state as StockLoaded).copyWith(searchQuery: query));
    }
  }

  void _startLiveFeed() {
    _liveFeedTimer?.cancel();
    _liveFeedTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (state is! StockLoaded) return;

      final currentState = state as StockLoaded;

      // If the user hit pause, we skip the math but keep the timer alive
      if (currentState.isPaused) return;

      final keys = currentState.stocks.keys.toList();
      final randomTicker = keys[Random().nextInt(keys.length)];
      final oldStock = currentState.stocks[randomTicker]!;

      final change = (Random().nextDouble() * 4) - 2;

      // We create a fresh map so Equatable knows the state actually changed
      final updatedMap = Map<String, StockModel>.from(currentState.stocks);
      updatedMap[randomTicker] = oldStock.copyWith(
        price: oldStock.price + change,
        netChange: oldStock.netChange + change,
      );

      // Broadcast the new prices to the UI
      emit(currentState.copyWith(stocks: updatedMap));
    });
  }

  @override
  Future<void> close() {
    _liveFeedTimer?.cancel(); // The mandatory Day 2 memory cleanup
    return super.close();
  }
}
