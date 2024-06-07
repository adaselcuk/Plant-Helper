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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'careInstructions': careInstructions,
      'lastWatered': lastWatered.toIso8601String(),
      'waterFrequency': waterFrequency,
      'lastSoilChange': lastSoilChange?.toIso8601String(),
      'soilFrequency': soilFrequency,
      'lastFertilized': lastFertilized?.toIso8601String(),
      'fertilizeFrequency': fertilizeFrequency,
    };
  }
}