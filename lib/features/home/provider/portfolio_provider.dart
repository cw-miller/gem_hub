import 'package:job_market/data/datasources/local/database_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'portfolio_provider.g.dart';

@riverpod
// ignore: deprecated_member_use_from_same_package
Future<Map<String, double>> portfolioData(Ref ref) async {
  final db = await DatabaseHelper().database;
  final List<Map<String, dynamic>> maps = await db.query('gemstones');

  double inventoryValue = 0;
  double realizedProfit = 0;

  for (var row in maps) {
    // 1. Sum up costs using underscore names
    final double itemCost = 
        (row['buying_price'] ?? 0.0).toDouble() +
        (row['treatment_cost'] ?? 0.0).toDouble() +
        (row['recut_cost'] ?? 0.0).toDouble() +
        (row['other_processing_cost'] ?? 0.0).toDouble() +
        (row['transport_cost'] ?? 0.0).toDouble() +
        (row['other_cost'] ?? 0.0).toDouble();

    // 2. Check "is_sold" (MATCH THE SCHEMA)
    final bool isSold = (row['is_sold'] ?? 0) == 1;

    if (isSold) {
      // ✅ Use "selling_price" (MATCH THE SCHEMA)
      final double sellingPrice = (row['selling_price'] ?? 0.0).toDouble();
      realizedProfit += (sellingPrice - itemCost);
    } else {
      // 💎 Use "target_price" (MATCH THE SCHEMA)
      inventoryValue += (row['target_price'] ?? 0.0).toDouble();
    }
  }

  return {
    'inventoryValue': inventoryValue,
    'realizedProfit': realizedProfit,
  };
}