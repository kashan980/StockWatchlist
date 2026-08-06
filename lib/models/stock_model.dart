class StockModel {
  final String symbol;
  final double price;
  final double netChange;

  StockModel({
    required this.symbol,
    required this.price,
    required this.netChange,
  });

  StockModel copyWith({double? price, double? netChange}) {
    return StockModel(
      symbol: symbol,
      price: price ?? this.price,
      netChange: netChange ?? this.netChange,
    );
  }
}
