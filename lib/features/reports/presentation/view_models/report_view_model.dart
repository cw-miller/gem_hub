import 'package:job_market/data/datasources/local/database_helper.dart';
import 'package:job_market/data/models/inventory/gem_filter.dart';
import 'package:job_market/data/models/inventory/gemstone_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_view_model.g.dart';

/// Provider to fetch and filter gemstones based on UI selection
@riverpod
Future<List<GemstoneModel>> filteredGemstones(
  // ignore: deprecated_member_use_from_same_package
  Ref ref, 
  {required GemFilter filter}
) async {
  final db = await DatabaseHelper().database;
  
  String? whereClause;
  List<dynamic>? whereArgs;
  List<String> conditions = [];
  List<dynamic> args = [];

  // Logic for Gem Type (Variety)
  if (filter.variety != null && filter.variety != 'All') {
    conditions.add('variety = ?'); 
    args.add(filter.variety);
  }

  // Logic for Date Range
  if (filter.dateRange != null) {
    conditions.add('date BETWEEN ? AND ?');
    args.add(filter.dateRange!.start.toIso8601String());
    args.add(filter.dateRange!.end.toIso8601String());
  }

  if (conditions.isNotEmpty) {
    whereClause = conditions.join(' AND ');
    whereArgs = args;
  }

  final List<Map<String, dynamic>> maps = await db.query(
    'gemstones',
    where: whereClause,
    whereArgs: whereArgs,
    orderBy: 'date DESC', // Added sorting so newest gems appear first
  );

  return maps.map((gemMap) => GemstoneModel.fromMap(gemMap)).toList();
}

/// NEW: Provider to fetch unique varieties currently in the database
@riverpod
Future<List<String>> gemstoneVarieties(Ref ref) async {
  final db = await DatabaseHelper().database;
  
  // Use SELECT DISTINCT to get unique names only
  final List<Map<String, dynamic>> maps = await db.query(
    'gemstones',
    columns: ['variety'],
    distinct: true,
  );

  // Extract strings, remove nulls/blanks, and sort alphabetically
  final varieties = maps
      .map((m) => m['variety'] as String?)
      .where((v) => v != null && v.isNotEmpty)
      .cast<String>()
      .toList();
  
  varieties.sort();

  // Return with 'All' at the top of the list
  return ['All', ...varieties];
}