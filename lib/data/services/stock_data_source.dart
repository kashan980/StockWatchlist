import 'dart:async';
import 'dart:math';
import '../models/stock.dart';
import 'package:flutter/material.dart';

class StockDataSource {

  final Random random = Random();

  final Map<String, Stock> stocks = {};

  final Map<String, StreamController<Stock>> controllers = {};

  Timer? timer;

  bool isRunning = false;



  StockDataSource(List<Stock> initialStocks) {

    for (var stock in initialStocks) {

      stocks[stock.symbol] = stock;


      controllers[stock.symbol] =
      StreamController<Stock>.broadcast();

    }

  }




  Stream<Stock> getStockStream(String symbol) {

    return controllers[symbol]!.stream;

  }





  void start() {


    if(isRunning) return;


    isRunning = true;


    timer = Timer.periodic(

      const Duration(seconds: 2),

          (_) {

        updateRandomStock();

      },

    );

  }





  void pause() {

    timer?.cancel();

    timer = null;

    isRunning = false;

  }





  void resume() {

    if(!isRunning){

      start();

    }

  }






  void updateRandomStock() {


    for(var symbol in stocks.keys){


      final oldStock = stocks[symbol]!;


      const double limit = 2;


      final movement =
          (random.nextDouble() * (limit * 2)) - limit;



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



      stocks[symbol] = updatedStock;



      controllers[symbol]!
          .add(updatedStock);



      debugPrint(
          "$symbol updated ${updatedStock.currentPrice}"
      );

    }

  }





  void dispose(){

    timer?.cancel();


    for(var controller in controllers.values){

      controller.close();

    }

  }

}