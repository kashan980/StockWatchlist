class Stock {
  final String symbol;
  final String name;
  final String sector;
  final double current_price;
  final double previous_close;
  final double change;
  final double change_percentage;
  final int volume;
  final bool is_active;

  Stock({
    required this.symbol,
    required this.name,
    required this.sector,
    required this.current_price,
    required this.previous_close,
    required this.change,
    required this.change_percentage,
    required this.volume,
    required this.is_active,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'].toString(),
      name: json['name'].toString(),
      sector: json['sector'].toString(),
      current_price: double.parse(json['current_price'].toString()),
      previous_close: double.parse(json['previous_close'].toString()),
      change: double.parse(json['change'].toString()),
      change_percentage: double.parse(json['change_percentage'].toString()),
      volume: int.parse(json['volume'].toString()),
      is_active: json['is_active'].toString() == "true",
    );
  }

  Stock copyWith({
    double? current_price,
    double? change,
    double? change_percentage,
  }) {
    return Stock(
      symbol: symbol,
      name: name,
      sector: sector,
      current_price: current_price ?? this.current_price,
      previous_close: previous_close,
      change: change ?? this.change,
      change_percentage: change_percentage ?? this.change_percentage,
      volume: volume,
      is_active: is_active,
    );
  }
}
