import 'package:flutter/material.dart';
import 'plant.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class AddPlantView extends StatefulWidget {
  final Function(Plant) addPlant;
  AddPlantView({required this.addPlant});
  @override
  _AddPlantViewState createState() => _AddPlantViewState();
}

class _AddPlantViewState extends State<AddPlantView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(); // this makes the text field controlled and editable if user wants to edit
  final _idController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _careInstructionsController = TextEditingController();
  final _lastWateredController = TextEditingController();
  final _waterFrequencyController = TextEditingController();
  final _lastSoilChangeController = TextEditingController();
  final _soilFrequencyController = TextEditingController();
  final _lastFertilizedController = TextEditingController();
  final _fertilizeFrequencyController = TextEditingController();

  @override
  void dispose() { 
    // disposing the controllers to free up memory - memory leaks avoided
    _nameController.dispose();
    _idController.dispose();
    _descriptionController.dispose();
    _careInstructionsController.dispose();
    _lastWateredController.dispose();
    _waterFrequencyController.dispose();
    _lastSoilChangeController.dispose();
    _soilFrequencyController.dispose();
    _lastFertilizedController.dispose();
    _fertilizeFrequencyController.dispose();
    super.dispose();
  }
  
  Plant newPlant = Plant(
    name: '',
    id: '',
    description: '',
    careInstructions: '',
    lastWatered: DateTime.now(),
    waterFrequency: 7,);
    // initialized plant with default values

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker(); //underscore in Dart represents the variable is private
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery); // XFile because can get path from the file class
    if (image != null) {
      setState(() {
        newPlant.image = File(image.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Plant'),
      ), 
      body: Padding(
        padding: EdgeInsets.all(8.0), // added padding to add negative space - cleaner look
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // scrolling added to the form
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) {
                  newPlant.name = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },

              ),
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'ID (Scientific name)'),
                onSaved: (value) {
                  newPlant.id = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an ID';
                  }
                  return null;
                },

              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  newPlant.description = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },

              ),
              TextFormField(
                controller: _careInstructionsController,
                decoration: InputDecoration(labelText: 'Care Instructions'),
                onSaved: (value) {
                  newPlant.careInstructions = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter care instructions';
                  }
                },
              ),
              TextFormField(
                controller: _lastWateredController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Last Watered'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      newPlant.lastWatered = date;
                    });
                  }
                },
              ),
              if (newPlant.lastWatered != null) Text('Selected date: ${DateFormat('MM/dd/yyyy').format(newPlant.lastWatered!)}'),
              TextFormField(
                controller: _waterFrequencyController,
                decoration: InputDecoration(labelText: 'Watering Frequency (days)'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onSaved: (value) {
                  // made 7 the default value for watering plants if user doesn't enter anything
                  newPlant.waterFrequency = int.tryParse(value ?? '7') ?? 7;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an watering frequency';
                  }
                  var parsedValue = int.tryParse(value);
                  if ( parsedValue == null || parsedValue <= 0) {
                    return 'Please enter a valid watering frequency';
                  }
                  return null;
                },

              ),
              
              TextFormField(
                controller: _lastSoilChangeController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Last Soil Change'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      newPlant.lastSoilChange = date;
                    });
                  }
                },
              ),
              if (newPlant.lastSoilChange != null) Text('Selected date: ${DateFormat('MM/dd/yyyy').format(newPlant.lastSoilChange!)}'),
              TextFormField(
                controller: _soilFrequencyController,
                decoration: InputDecoration(labelText: 'Soil Change Frequency (days)'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onSaved: (value) {
                  newPlant.soilFrequency = int.tryParse(value ?? '0');
                },
              ), 
              TextFormField(
                controller: _lastFertilizedController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Last Fertilized'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      newPlant.lastFertilized = date;
                    });
                  }
                },
              ),
              if (newPlant.lastFertilized != null) Text('Selected date: ${DateFormat('MM/dd/yyyy').format(newPlant.lastFertilized!)}'),
              TextFormField(
                controller: _fertilizeFrequencyController,
                decoration: InputDecoration(labelText: 'Fertilizing Frequency (days)'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onSaved: (value) {
                  newPlant.fertilizeFrequency = int.tryParse(value ?? '0');
                },
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Add Image'),
              ),
              ElevatedButton(
                // added onPressed to submit the form
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // does not submit form if there is an invalid field the user entered
                    _formKey.currentState!.save();
                    // saves the form with appropriate values
                    widget.addPlant(newPlant);
                  }
                },
                child: Text('Submit'),
              )
            ])
          )
        )
      )
    );
      
  }
  
}