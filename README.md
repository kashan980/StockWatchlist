# Real-Time Stock Watchlist - Day 2 Architecture

## Architecture Overview
This application utilizes a strict 3-tier architecture managed by `flutter_bloc` to ensure separation of concerns, scalability, and zero business logic within the UI.

1. **Data Layer (`StockRepository`)**: Manages the Dio HTTP client. Responsible strictly for fetching and parsing the JSON payload into Dart models.
2. **Domain/State Layer (`StockCubit` & `StockState`)**: Manages the mock WebSocket timer. Emits strongly typed, immutable states (`StockLoading`, `StockLoaded`, `StockError`). The `isPaused` and `searchQuery` parameters exist here, allowing data transformation before it ever hits the UI.
3. **Presentation Layer**: Dumb UI components.

## Performance & Optimization
To satisfy the strict rebuild constraints, the main `ListView` relies on `BlocSelector` at the row level.
Instead of rebuilding the entire list when a new `StockLoaded` state is emitted, `BlocSelector` filters the state down to the specific `StockModel`. When the Cubit updates the price of `PSO`, only the `PSO` widget rebuilds, leaving the rest of the list completely untouched. Memory is safely managed via Cubit's native `close()` override which aggressively cancels all active timers.