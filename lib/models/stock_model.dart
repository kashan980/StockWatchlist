class StockModel {
  final String symbol;
  final double price;
  final double netChange;
  final double openPrice; // Added: Initial opening price of the stock
  final String marketOpen; // Added: Market open time string (e.g., "09:30 AM")
  final String
  marketClose; // Added: Market close time string (e.g., "03:30 PM")

  StockModel({
    required this.symbol,
    required this.price,
    required this.netChange,
    required this.openPrice,
    required this.marketOpen,
    required this.marketClose,
  });

  /// Computed getter for percentage change relative to market open price
  double get percentChange {
    if (openPrice == 0) return 0.0;
    return ((price - openPrice) / openPrice) * 100;
  }

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      symbol: json['symbol'] ?? '',
      price: (json['price'] as num).toDouble(),
      netChange: (json['netChange'] as num).toDouble(),
      openPrice:
          (json['openPrice'] as num?)?.toDouble() ??
          (json['price'] as num).toDouble(),
      marketOpen: json['marketOpen'] ?? '09:30 AM',
      marketClose: json['marketClose'] ?? '03:30 PM',
    );
  }
}
