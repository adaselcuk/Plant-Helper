class Plant {
  final String name;
  final String id;
  final String description;
  final String? imageUrl;
  final String careInstructions;
  final DateTime lastWatered;
  final int waterFrequency;
  final DateTime? lastSoilChange; // the question marks make it optional parameter
  final int? soilFrequency;
  final DateTime? lastFertilized;
  final int? fertilizeFrequency;
  
  Plant({required this.name, required this.id, required this.description, 
  required this.careInstructions, required this.lastWatered, 
  required this.waterFrequency,
  this.imageUrl, this.lastSoilChange, this.soilFrequency,
  this.lastFertilized, this.fertilizeFrequency});
}