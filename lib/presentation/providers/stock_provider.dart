// import 'dart:async';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../data/models/stock.dart';
// import '../../data/repository/stock_repository.dart';
// import '../../data/services/api_service.dart';
// import '../../domain/state/stock_state.dart';
//
// // Api Provider
// final apiServiceProvider = Provider((ref) {
//   return ApiService();
// });
// // Repository Provider
// final stockRepositoryProvider = Provider((ref) {
//   return StockRepository(apiService: ref.read(apiServiceProvider));
// });
// class StockNotifier extends Notifier<StockState> {
//   late StockRepository repository;
//   // Store stream subscriptions
//   final List<StreamSubscription> subscriptions = [];
//
//   // Complete stock list
//   // Never changes because of search
//   List<Stock> allStocks = [];
//   // Current search text
//   String searchQuery = "";
//   @override
//   StockState build() {
//     repository = ref.read(stockRepositoryProvider);
//     // Load stocks after provider creation
//     Future.microtask(() {
//       loadStocks();
//     });
//     // Clean resources
//     ref.onDispose(() {
//       for (var subscription in subscriptions) {
//         subscription.cancel();
//       }
//       repository.dispose();
//     });
//     return StockLoading();
//   }
//
//   Future<void> loadStocks() async {
//     try {
//       state = StockLoading();
//       final stocks = await repository.getStocks();
//       // Save original list
//       allStocks = stocks;
//       state = StockLoaded(stocks);
//       // Listen to every stock stream
//       for (var stock in stocks) {
//         final subscription = repository.getStockStream(stock.symbol).listen((
//           updatedStock,
//         ) {
//           final updatedList = allStocks.map((item) {
//             if (item.symbol == updatedStock.symbol) {
//               return updatedStock;
//             }
//             return item;
//           }).toList();
//           // Update complete list
//           allStocks = updatedList;
//           // Apply search filter again
//           if (searchQuery.isEmpty) {
//             state = StockLoaded(allStocks);
//           } else {
//             final filteredList = allStocks.where((stock) {
//               return stock.symbol.toLowerCase().contains(
//                 searchQuery.toLowerCase(),
//               );
//             }).toList();
//
//             state = StockLoaded(filteredList);
//           }
//         });
//
//         subscriptions.add(subscription);
//       }
//     } catch (e) {
//       state = StockError(e.toString());
//     }
//   }
//   // Pause live feed
//   void pauseFeed() {
//     repository.pauseFeed();
//   }
//   // Resume live feed
//   void resumeFeed() {
//     repository.resumeFeed();
//   }
//   // Search stocks by symbol
//   void searchStocks(String query) {
//     searchQuery = query;
//     if (query.isEmpty) {
//       state = StockLoaded(allStocks);
//       return;
//     }
//     final filteredStocks = allStocks.where((stock) {
//       return stock.symbol.toLowerCase().contains(query.toLowerCase());
//     }).toList();
//     state = StockLoaded(filteredStocks);
//   }
// }
// final stockProvider = NotifierProvider<StockNotifier, StockState>(
//   StockNotifier.new,
// );

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/stock.dart';
import '../../data/repository/stock_repository.dart';
import '../../data/services/api_service.dart';
import '../../domain/state/stock_state.dart';

// API Provider
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// Repository Provider
final stockRepositoryProvider = Provider<StockRepository>((ref) {
  return StockRepository(apiService: ref.read(apiServiceProvider));
});

class StockNotifier extends Notifier<StockState> {
  late StockRepository repository;

  // Store stream subscriptions
  final List<StreamSubscription<Stock>> subscriptions = [];

  // Complete stock list.
  // This list is NOT affected by search.
  List<Stock> allStocks = [];

  // Current search text
  String searchQuery = '';

  @override
  StockState build() {
    repository = ref.read(stockRepositoryProvider);

    // Load stocks after provider creation
    Future.microtask(() {
      loadStocks();
    });

    // Clean resources
    ref.onDispose(() {
      for (final subscription in subscriptions) {
        subscription.cancel();
      }

      repository.dispose();
    });

    return StockLoading();
  }

  // Load stocks from repository
  Future<void> loadStocks() async {
    try {
      state = StockLoading();

      final stocks = await repository.getStocks();

      // Save the complete/original list
      allStocks = stocks;

      // Initially show all stocks
      state = StockLoaded(allStocks);

      // Listen to every stock stream
      for (final stock in stocks) {
        final subscription = repository.getStockStream(stock.symbol).listen((
          updatedStock,
        ) {
          // Update the stock inside the complete list
          allStocks = allStocks.map((item) {
            if (item.symbol == updatedStock.symbol) {
              return updatedStock;
            }

            return item;
          }).toList();

          // Update UI while respecting the current search
          _updateStateWithSearch();
        });

        subscriptions.add(subscription);
      }
    } catch (e) {
      state = StockError(e.toString());
    }
  }

  // Apply the current search query and update state
  void _updateStateWithSearch() {
    // If there is no search query,
    // show the complete list.
    if (searchQuery.isEmpty) {
      state = StockLoaded(allStocks);
      return;
    }

    // Otherwise filter the complete list.
    final filteredStocks = allStocks.where((stock) {
      return stock.symbol.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    state = StockLoaded(filteredStocks);
  }

  // Pause live feed
  void pauseFeed() {
    repository.pauseFeed();
  }

  // Resume live feed
  void resumeFeed() {
    repository.resumeFeed();
  }

  // Search stocks by symbol
  void searchStocks(String query) {
    // Save the current search text
    searchQuery = query;

    // Apply the search
    _updateStateWithSearch();
  }
}

// Stock Provider
final stockProvider = NotifierProvider<StockNotifier, StockState>(
  StockNotifier.new,
);
