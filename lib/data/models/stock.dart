class Stock {
  final String symbol;
  final String name;
  final String sector;
  final double currentPrice;
  final double previousClose;
  final double change;
  final double changePercentage;
  final int volume;
  final bool isActive;

  Stock({
    required this.symbol,
    required this.name,
    required this.sector,
    required this.currentPrice,
    required this.previousClose,
    required this.change,
    required this.changePercentage,
    required this.volume,
    required this.isActive,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'].toString(),
      name: json['name'].toString(),
      sector: json['sector'].toString(),
      currentPrice: double.parse(json['current_price'].toString()),
      previousClose: double.parse(json['previous_close'].toString()),
      change: double.parse(json['change'].toString()),
      changePercentage: double.parse(json['change_percentage'].toString()),
      volume: int.parse(json['volume'].toString()),
      isActive: json['is_active'].toString() == "true",
    );
  }

  Stock copyWith({
    double? currentPrice,
    double? change,
    double? changePercentage,
  }) {
    return Stock(
      symbol: symbol,
      name: name,
      sector: sector,
      currentPrice: currentPrice ?? this.currentPrice,
      previousClose: previousClose,
      change: change ?? this.change,
      changePercentage: changePercentage ?? this.changePercentage,
      volume: volume,
      isActive: isActive,
    );
  }
}
