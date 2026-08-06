import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/stock_model.dart';

class StockRepository {
  final Dio _dio = Dio();

  Future<Map<String, StockModel>> fetchStocks() async {
    final response = await _dio.get(
      'https://gist.githubusercontent.com/juni12891226/937ac4583eb7407416830652df1c9fbc/raw/c7e96c1691ed15dd9ded27018cd8742ba5d1a0f6/gistfile1.txt',
    );

    final Map<String, dynamic> data = response.data is String
        ? jsonDecode(response.data)
        : response.data;

    final List<dynamic> stocksList = data['stocks'];
    final Map<String, StockModel> stockMap = {};

    for (var item in stocksList) {
      final symbol = item['symbol'];
      stockMap[symbol] = StockModel(
        symbol: symbol,
        price: (item['current_price'] as num).toDouble(),
        netChange: (item['change'] as num).toDouble(),
      );
    }
    return stockMap;
  }
}
