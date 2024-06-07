import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'plant.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  DatabaseHelper._internal();

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'plants.db');

    return await openDatabase(path,
    version: 1,
    onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE plants(
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        careInstructions TEXT,
        lastWatered TEXT,
        waterFrequency INTEGER,
        lastSoilChange TEXT,
        soilFrequency INTEGER,
        lastFertilized TEXT,
        fertilizeFrequency INTEGER
      )
    ''');
  }

  Future<int> insertPlant(Plant plant) async {
    final db = await this.db;
    return await db!.insert('plants', plant.toMap());
  }

  Future<List<Plant>> getPlants() async {
    final db = await this.db;
    final List<Map<String, dynamic>> maps = await db!.query('plants');

    return List.generate(maps.length, (i) {
      return Plant(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        careInstructions: maps[i]['careInstructions'],
        lastWatered: DateTime.parse(maps[i]['lastWatered']),
        waterFrequency: maps[i]['waterFrequency'],
        lastSoilChange: maps[i]['lastSoilChange'] != null ? DateTime.parse(maps[i]['lastSoilChange']) : null,
        soilFrequency: maps[i]['soilFrequency'],
        lastFertilized: maps[i]['lastFertilized'] != null ? DateTime.parse(maps[i]['lastFertilized']) : null,
        fertilizeFrequency: maps[i]['fertilizeFrequency'],
      );
    });
  }
}