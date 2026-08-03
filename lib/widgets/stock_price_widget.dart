import 'dart:async';

import 'package:flutter/material.dart';

import '../models/stock.dart';
import '../services/mock_stock_service.dart';
import '../screens/stock_detailed_screen.dart';

class StockPriceWidget extends StatefulWidget {
  final Stock stock;
  final MockStockService service;

  const StockPriceWidget({
    super.key,
    required this.stock,
    required this.service,
  });

  @override
  State<StockPriceWidget> createState() => _StockPriceWidgetState();
}

class _StockPriceWidgetState extends State<StockPriceWidget> {
  late Stock currentStock;

  StreamSubscription<Stock>? subscription;

  Color? highlightColor;

  @override
  void initState() {
    super.initState();

    currentStock = widget.stock;

    subscription = widget.service.getStockStream(widget.stock.symbol).listen((
      updatedStock,
    ) {
      final bool priceIncreased =
          updatedStock.current_price > currentStock.current_price;

      setState(() {
        currentStock = updatedStock;

        highlightColor = priceIncreased
            ? Colors.green.withValues(alpha: 0.25)
            : Colors.red.withValues(alpha: 0.25);
      });

      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            highlightColor = null;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    subscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isUp = currentStock.change >= 0;

    return InkWell(
      borderRadius: BorderRadius.circular(12),

      onTap: () {
        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (_) =>
                StockDetailScreen(stock: currentStock, service: widget.service),
          ),
        );
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),

        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

        decoration: BoxDecoration(
          color: highlightColor ?? Colors.transparent,

          borderRadius: BorderRadius.circular(12),
        ),

        child: Card(
          child: ListTile(
            title: Text(
              currentStock.symbol,

              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            subtitle: Text(currentStock.name),

            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              crossAxisAlignment: CrossAxisAlignment.end,

              children: [
                Text(
                  currentStock.current_price.toStringAsFixed(2),

                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                Text(
                  "${isUp ? '+' : ''}"
                  "${currentStock.change.toStringAsFixed(2)}",

                  style: TextStyle(
                    color: isUp ? Colors.green : Colors.red,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
