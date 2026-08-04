import 'package:flutter_test/flutter_test.dart';
import 'package:stockwatch/main.dart'; // Make sure this matches your project name

void main() {
  testWidgets('App launches successfully smoke test', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StockWatchApp());

    // Verify that the Watchlist Screen loaded by checking for the AppBar title
    expect(find.text('Live Market Watch'), findsOneWidget);
  });
}
