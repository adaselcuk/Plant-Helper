import 'package:flutter/material.dart';
import 'plant.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'form_data.dart';
import 'package:provider/provider.dart';
import 'plant_list.dart';

class AddPlantView extends StatefulWidget {
  final Function(Plant) addPlant;
  AddPlantView({Key? key, required this.addPlant});

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Plant newPlant = Plant(
      //   name: _nameController.text,
      //   id: _idController.text,
      //   description: _descriptionController.text,
      //   careInstructions: _careInstructionsController.text,
      //   lastWatered: DateTime.parse(_lastWateredController.text),
      //   waterFrequency: int.parse(_waterFrequencyController.text),
      //   lastSoilChange: DateTime.parse(_lastSoilChangeController.text),
      //   soilFrequency: int.parse(_soilFrequencyController.text),
      //   lastFertilized: DateTime.parse(_lastFertilizedController.text),
      //   fertilizeFrequency: int.parse(_fertilizeFrequencyController.text),
      // );
      FormData formData = FormData();
      formData.updateName(_nameController.text);
      formData.updateId(_idController.text);
      formData.updateDescription(_descriptionController.text);
      formData.updateCareInstructions(_careInstructionsController.text);
      formData.updateLastWatered(DateTime.parse(_lastWateredController.text));
      formData.updateWaterFrequency(int.parse(_waterFrequencyController.text));
      formData.updateLastSoilChange(DateTime.parse(_lastSoilChangeController.text));
      formData.updateLastFertilized(DateTime.parse(_lastFertilizedController.text));
      formData.updateFertilizeFrequency(int.parse(_fertilizeFrequencyController.text));
      Provider.of<PlantList>(context, listen: false).addPlant(newPlant);
    }
  }

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
              Text(
                '* indicates required fields',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 216, 91, 82),
                ),
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name *'),
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
                decoration: InputDecoration(labelText: 'ID (Scientific name) *'),
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
                decoration: InputDecoration(labelText: 'Description *'),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
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
                decoration: InputDecoration(labelText: 'Care Instructions *'),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
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
                decoration: InputDecoration(labelText: 'Last Watered *'),
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
                decoration: InputDecoration(labelText: 'Watering Frequency (days) *'),
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
                  newPlant.soilFrequency = value == null || value.isEmpty
                  ? null
                  :int.tryParse(value ?? '0');
                },
                validator: (value) {
                  var parsedValue = int.tryParse(value ?? '');
                  if (parsedValue != null && parsedValue <= 0) {
                    return 'Please enter a valid soil change frequency';
                  }
                  return null;
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
                  newPlant.fertilizeFrequency = value == null || value.isEmpty
                  ? null
                  :int.tryParse(value ?? '0');
                },
                validator: (value) {
                  var parsedValue = int.tryParse(value ?? '');
                  if ( parsedValue != null && parsedValue <= 0) {
                    return 'Please enter a valid fertilizing frequency';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Add Image'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit to add plant'),
              ),
              SizedBox(height: 20),
            ])
          )
        )
      )
    );
      
  }
  
}