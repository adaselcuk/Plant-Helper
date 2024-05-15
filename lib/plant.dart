import 'dart:io';

class Plant {
  String name;
  String id;
  String description;
  File? image;
  String careInstructions;
  DateTime lastWatered;
  int waterFrequency;
  DateTime? lastSoilChange; // the question marks make it optional parameter
  int? soilFrequency;
  DateTime? lastFertilized;
  int? fertilizeFrequency;
  
  Plant({required this.name, required this.id, required this.description, 
  required this.careInstructions, required this.lastWatered, 
  required this.waterFrequency,
  this.image, this.lastSoilChange, this.soilFrequency,
  this.lastFertilized, this.fertilizeFrequency});
}