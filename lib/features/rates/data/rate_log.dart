import 'package:flutter/foundation.dart';

/// Focused logging so it is verifiable that the network call actually ran.
/// Debug builds only, and never carries user data.
void logRates(String message) {
  if (kDebugMode) debugPrint('[ExchangeRate] $message');
}
