import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/stock_cubit.dart';
import 'data/stock_repository.dart';
import 'screens/watchlist_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => StockRepository(),
      child: BlocProvider(
        create: (context) =>
            StockCubit(context.read<StockRepository>())..loadStocks(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'StockWatch',
          theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
          home: const WatchlistScreen(),
        ),
      ),
    );
  }
}
