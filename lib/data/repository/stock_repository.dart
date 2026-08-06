import 'dart:async';
import '../models/stock.dart';
import '../services/api_service.dart';
import '../services/stock_data_source.dart';

class StockRepository {
  final ApiService apiService;
  StockDataSource? dataSource;
  StockRepository({
    required this.apiService,
  });

  Future<List<Stock>> getStocks() async {
    final stocks = await apiService.fetchStocks();
    dataSource = StockDataSource(stocks);
    dataSource!.start();
    return stocks;
  }
  Stream<Stock> getStockStream(String symbol) {
    return dataSource!.getStockStream(symbol);
  }
  void dispose(){
    dataSource?.dispose();
  }
}