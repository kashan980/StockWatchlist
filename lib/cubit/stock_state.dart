import 'package:equatable/equatable.dart';

import '../models/stock_model.dart';

abstract class StockState extends Equatable {
  const StockState();

  @override
  List<Object?> get props => [];
}

class StockLoading extends StockState {}

class StockLoaded extends StockState {
  final Map<String, StockModel> stocks;
  final bool isPaused;
  final String searchQuery;

  const StockLoaded({
    required this.stocks,
    this.isPaused = false,
    this.searchQuery = '',
  });

  // This automatically handles the Day 2 Search requirement!
  List<StockModel> get filteredStocks {
    if (searchQuery.isEmpty) return stocks.values.toList();
    return stocks.values
        .where(
          (stock) =>
              stock.symbol.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  // copyWith allows us to update one piece of data without destroying the rest
  StockLoaded copyWith({
    Map<String, StockModel>? stocks,
    bool? isPaused,
    String? searchQuery,
  }) {
    return StockLoaded(
      stocks: stocks ?? this.stocks,
      isPaused: isPaused ?? this.isPaused,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [stocks, isPaused, searchQuery];
}

class StockError extends StockState {
  final String message;
  const StockError(this.message);

  @override
  List<Object?> get props => [message];
}
