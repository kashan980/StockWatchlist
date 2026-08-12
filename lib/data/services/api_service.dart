import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/stock.dart';

class ApiService {
  final Dio dio = Dio();

  Future<List<Stock>> fetchStocks() async {
    try {
      final response = await dio.get(
        'https://gist.githubusercontent.com/juni12891226/937ac4583eb7407416830652df1c9fbc/raw/c7e96c1691ed15dd9ded27018cd8742ba5d1a0f6/gistfile1.txt',
        //queryParameters: {'sector': 'Fertilizer'},
        options: Options(
          headers: {
            'Accept': 'application/json',
          }
        )
      );

      //API REQUEST LOGS debugPrint
      ('========== API REQUEST ==========');
      debugPrint('METHOD: ${response.requestOptions.method}');
      debugPrint('URL: ${response.requestOptions.uri}');
      debugPrint('QUERY PARAMETERS: ${response.requestOptions.queryParameters}');
      debugPrint('HEADERS: ${response.requestOptions.headers}');
      debugPrint('REQUEST BODY: ${response.requestOptions.data}');
      debugPrint('==================================');
      // API RESPONSE LOGS


      debugPrint('========== API RESPONSE ==========');
      debugPrint('STATUS CODE: ${response.statusCode}');          //Explore these logs
      debugPrint('STATUS MESSAGE: ${response.statusMessage}');
      debugPrint('RESPONSE HEADERS: ${response.headers}');
      debugPrint('RESPONSE BODY: ${response.data}');
      debugPrint('==================================');

      //debugPrint(response.data.runtimeType);

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      final List stocks = data['stocks'];

      return stocks.map((stock) => Stock.fromJson(stock)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
