import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/stock_cubit.dart';
import '../cubit/stock_state.dart';
import '../models/stock_model.dart';
import '../screens/stock_detail_screen.dart'; // Make sure this matches your Day 1 file name!

class StockRow extends StatelessWidget {
  final String symbol;

  const StockRow({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StockCubit, StockState, StockModel?>(
      selector: (state) {
        if (state is StockLoaded) {
          return state.stocks[symbol];
        }
        return null;
      },
      builder: (context, stock) {
        if (stock == null) return const SizedBox.shrink();
        return _StockRowDisplay(stock: stock);
      },
    );
  }
}

class _StockRowDisplay extends StatefulWidget {
  final StockModel stock;

  const _StockRowDisplay({required this.stock});

  @override
  State<_StockRowDisplay> createState() => _StockRowDisplayState();
}

class _StockRowDisplayState extends State<_StockRowDisplay> {
  Color _highlightColor = Colors.transparent;
  Timer? _highlightTimer;

  @override
  void didUpdateWidget(covariant _StockRowDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Compare new price to old price to trigger the blinking effect
    if (widget.stock.price > oldWidget.stock.price) {
      _triggerHighlight(Colors.green.withOpacity(0.3));
    } else if (widget.stock.price < oldWidget.stock.price) {
      _triggerHighlight(Colors.red.withOpacity(0.3));
    }
  }

  void _triggerHighlight(Color color) {
    _highlightTimer?.cancel();
    setState(() => _highlightColor = color);
    _highlightTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _highlightColor = Colors.transparent);
    });
  }

  @override
  void dispose() {
    _highlightTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = widget.stock.netChange >= 0;

    // InkWell adds the ripple effect and the onTap navigation
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                StockDetailScreen(symbol: widget.stock.symbol),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: _highlightColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.stock.symbol,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rs ${widget.stock.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '${isPositive ? "+" : ""}${widget.stock.netChange.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
