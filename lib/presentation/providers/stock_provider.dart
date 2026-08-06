import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/stock_repository.dart';
import '../../data/services/api_service.dart';
import '../../domain/state/stock_state.dart';


// Api Provider
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});


// Repository Provider
final stockRepositoryProvider = Provider<StockRepository>((ref) {

  return StockRepository(
    apiService: ref.read(apiServiceProvider),
  );

});


// Stock Notifier
class StockNotifier extends Notifier<StockState> {

  late StockRepository repository;

  final List<StreamSubscription> subscriptions = [];


  @override
  StockState build() {

    repository = ref.read(stockRepositoryProvider);


    Future.microtask(() {

      loadStocks();

    });


    ref.onDispose(() {

      for (var subscription in subscriptions) {

        subscription.cancel();

      }


      repository.dispose();

    });


    return StockLoading();

  }



  Future<void> loadStocks() async {

    try {


      state = StockLoading();


      final stocks =
      await repository.getStocks();



      state = StockLoaded(stocks);



      // Listen to every stock stream
      for (var stock in stocks) {


        final subscription =

        repository
            .getStockStream(stock.symbol)
            .listen((updatedStock) {


          final currentState = state;


          if (currentState is StockLoaded) {


            final updatedList =
            currentState.stocks.map((item) {


              if (item.symbol ==
                  updatedStock.symbol) {

                return updatedStock;

              }


              return item;


            }).toList();



            state = StockLoaded(updatedList);

          }


        });


        subscriptions.add(subscription);

      }



    } catch(e) {


      state = StockError(
        e.toString(),
      );


    }

  }


}



final stockProvider =
NotifierProvider<StockNotifier, StockState>(
  StockNotifier.new,
);