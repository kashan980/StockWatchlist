import 'dart:async';

import 'package:flutter/material.dart';

import '../models/stock_model.dart';
import '../screens/stock_detail_screen.dart';

class StockRow extends StatefulWidget {
  final ValueNotifier<StockModel> stockNotifier;

  const StockRow({super.key, required this.stockNotifier});

  @override
  State<StockRow> createState() => _StockRowState();
}

class _StockRowState extends State<StockRow> {
  Color _highlightColor = Colors.transparent;
  Timer? _highlightTimer;
  late double _previousPrice;

  @override
  void initState() {
    super.initState();
    _previousPrice = widget.stockNotifier.value.price;
    // Listen to the notifier strictly for the color flash effect
    widget.stockNotifier.addListener(_onPriceChanged);
  }

  void _onPriceChanged() {
    if (!mounted) return;

    final newPrice = widget.stockNotifier.value.price;
    if (newPrice > _previousPrice) {
      _triggerHighlight(Colors.green.withValues(alpha: 0.3)); // Green for up
    } else if (newPrice < _previousPrice) {
      _triggerHighlight(Colors.red.withValues(alpha: 0.3)); // Red for down
    }
    _previousPrice = newPrice;
  }

  void _triggerHighlight(Color color) {
    _highlightTimer?.cancel();
    setState(() => _highlightColor = color);

    // Briefly highlight, then return to transparent
    _highlightTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _highlightColor = Colors.transparent);
    });
  }

  @override
  void dispose() {
    // CRITICAL: Prevent memory leaks when widget is unmounted
    widget.stockNotifier.removeListener(_onPriceChanged);
    _highlightTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: _highlightColor,
      // ValueListenableBuilder intercepts the rebuild. Only this ListTile rebuilds!
      child: ValueListenableBuilder<StockModel>(
        valueListenable: widget.stockNotifier,
        builder: (context, stock, child) {
          final isPositive = stock.netChange >= 0;

          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      StockDetailScreen(stockNotifier: widget.stockNotifier),
                ),
              );
            },
            title: Text(
              stock.symbol,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            // Find the trailing Column in stock_row.dart and update the percentage text display:
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rs ${stock.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${isPositive ? '+' : ''}${stock.netChange.toStringAsFixed(2)} (${isPositive ? '+' : ''}${stock.percentChange.toStringAsFixed(2)}%)',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
