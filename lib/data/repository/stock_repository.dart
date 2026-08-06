import '../services/api_service.dart';
import '../services/stock_data_source.dart';
import '../models/stock.dart';

class StockRepository {
  final ApiService apiService;
  final StockDataSource dataSource;


  StockRepository({
    required this.apiService,
    required this.dataSource,

});

  Future<List<Stock>> getStocks(){
    return apiService.fetchStocks();
  }
  Stream<Stock> getStockStream(String symbol) {
    return dataSource.getStockStream(symbol);
  }

  void startFeed(){
    dataSource.start();
  }
  void dispose(){
    dataSource.dispose();
  }

  }
