import 'package:flutter/foundation.dart';

class FormData extends ChangeNotifier {
  String name = '';
  String id = '';
  String description = '';
  String careInstructions = '';
  DateTime lastWatered = DateTime.now();
  int waterFrequency = 7;
  DateTime lastFertilized = DateTime.now();
  int fertilizeFrequency = 30;
  DateTime lastSoilChange = DateTime.now();
  int soilChangeFrequency = 365;
  String imageUrl = '';

  void updateName(String newName) {
    name = newName;
    notifyListeners();
  }

  void updateId(String newId) {
    id = newId;
    notifyListeners();
  }

  void updateDescription(String newDescription) {
    description = newDescription;
    notifyListeners();
  }

  void updateCareInstructions(String newCareInstructions) {
    careInstructions = newCareInstructions;
    notifyListeners();
  }

  void updateLastWatered(DateTime newLastWatered) {
    lastWatered = newLastWatered;
    notifyListeners();
  }

  void updateWaterFrequency(int newWaterFrequency) {
    waterFrequency = newWaterFrequency;
    notifyListeners();
  }

  void updateLastFertilized(DateTime newLastFertilized) {
    lastFertilized = newLastFertilized;
    notifyListeners();
  }

  void updateFertilizeFrequency(int? newFertilizeFrequency) {
    int? fertilizeFrequency = newFertilizeFrequency;
    notifyListeners();
  }

  void updateLastSoilChange(DateTime newLastSoilChange) {
    lastSoilChange = newLastSoilChange;
    notifyListeners();
  }

  void updateSoilChangeFrequency(int ?newSoilChangeFrequency) {
    int? soilChangeFrequency = newSoilChangeFrequency;
    notifyListeners();
  }

  void updateImageUrl(String newImageUrl) {
    imageUrl = newImageUrl;
    notifyListeners();
  }
}