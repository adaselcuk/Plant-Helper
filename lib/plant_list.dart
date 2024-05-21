import 'package:flutter/foundation.dart';
import 'plant.dart';

class PlantList extends ChangeNotifier {
  final List<Plant> _plants = [];

  List<Plant> get plants => _plants;

  void addPlant(Plant plant) {
    _plants.add(plant);
    notifyListeners();
  }

  void removePlant(Plant plant) {
    _plants.remove(plant);
    notifyListeners();
  }
}