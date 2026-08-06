import '../../data/models/stock.dart';

abstract class StockState {}
class StockLoading extends StockState {}
class StockLoaded extends StockState {
  final List<Stock> stocks;

  StockLoaded(this.stocks);

}

class StockError extends StockState {
  final String message;
  StockError(this.message);

}