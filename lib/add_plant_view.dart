import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'plant.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'form_data.dart';
import 'package:provider/provider.dart';
import 'plant_list.dart';
import 'package:shared_preferences/shared_preferences';

class AddPlantView extends StatefulWidget {
  final Function(Plant) addPlant;
  AddPlantView({Key? key, required this.addPlant});

  @override
  _AddPlantViewState createState() => _AddPlantViewState();
}

class _AddPlantViewState extends State<AddPlantView> with WidgetsBindingObserver{
  final _formKey = GlobalKey<FormState>();
  // final _nameController = TextEditingController(); // this makes the text field controlled and editable if user wants to edit
  // final _idController = TextEditingController();
  // final _descriptionController = TextEditingController();
  // final _careInstructionsController = TextEditingController();
  // final _lastWateredController = TextEditingController();
  // final _waterFrequencyController = TextEditingController();
  // final _lastSoilChangeController = TextEditingController();
  // final _soilFrequencyController = TextEditingController();
  // final _lastFertilizedController = TextEditingController();
  // final _fertilizeFrequencyController = TextEditingController();
  FormData _formData = FormData();

  // void _submitForm() {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //     // Plant newPlant = Plant(
  //     //   name: _nameController.text,
  //     //   id: _idController.text,
  //     //   description: _descriptionController.text,
  //     //   careInstructions: _careInstructionsController.text,
  //     //   lastWatered: DateTime.parse(_lastWateredController.text),
  //     //   waterFrequency: int.parse(_waterFrequencyController.text),
  //     //   lastSoilChange: DateTime.parse(_lastSoilChangeController.text),
  //     //   soilFrequency: int.parse(_soilFrequencyController.text),
  //     //   lastFertilized: DateTime.parse(_lastFertilizedController.text),
  //     //   fertilizeFrequency: int.parse(_fertilizeFrequencyController.text),
  //     // );
  //     FormData formData = FormData();
  //     formData.updateName(_nameController.text);
  //     formData.updateId(_idController.text);
  //     formData.updateDescription(_descriptionController.text);
  //     formData.updateCareInstructions(_careInstructionsController.text);
  //     formData.updateLastWatered(DateTime.parse(_lastWateredController.text));
  //     formData.updateWaterFrequency(int.parse(_waterFrequencyController.text));
  //     formData.updateLastSoilChange(DateTime.parse(_lastSoilChangeController.text));
  //     formData.updateLastFertilized(DateTime.parse(_lastFertilizedController.text));
  //     formData.updateFertilizeFrequency(int.parse(_fertilizeFrequencyController.text));
  //     Provider.of<PlantList>(context, listen: false).addPlant(newPlant);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadFormData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      _saveFormData();
    }
  }

  void _loadFormData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _formData.name = prefs.getString('name') ?? '';
      _formData.id = prefs.getString('id') ?? '';
      _formData.description = prefs.getString('description') ?? '';
      _formData.careInstructions = prefs.getString('careInstructions') ?? '';
      _formData.lastWatered = DateTime.parse(prefs.getString('lastWatered') ?? '');
      _formData.waterFrequency = prefs.getInt('waterFrequency') ?? 7;
      _formData.lastSoilChange = DateTime.parse(prefs.getString('lastSoilChange') ?? '');
      _formData.soilChangeFrequency = prefs.getInt('soilChangeFrequency') ?? 365;
      _formData.lastFertilized = DateTime.parse(prefs.getString('lastFertilized') ?? '');
      _formData.fertilizeFrequency = prefs.getInt('fertilizeFrequency') ?? 30;
    });
  }

  void _saveFormData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', _formData.name);
    prefs.setString('id', _formData.id);
    prefs.setString('description', _formData.description);
    prefs.setString('careInstructions', _formData.careInstructions);
    prefs.setString('lastWatered', _formData.lastWatered.toString());
    prefs.setInt('waterFrequency', _formData.waterFrequency);
    prefs.setString('lastSoilChange', _formData.lastSoilChange.toString());
    prefs.setInt('soilChangeFrequency', _formData.soilChangeFrequency);
    prefs.setString('lastFertilized', _formData.lastFertilized.toString());
    prefs.setInt('fertilizeFrequency', _formData.fertilizeFrequency);
  }
  // void dispose() { 
  //   // disposing the controllers to free up memory - memory leaks avoided
  //   _nameController.dispose();
  //   _idController.dispose();
  //   _descriptionController.dispose();
  //   _careInstructionsController.dispose();
  //   _lastWateredController.dispose();
  //   _waterFrequencyController.dispose();
  //   _lastSoilChangeController.dispose();
  //   _soilFrequencyController.dispose();
  //   _lastFertilizedController.dispose();
  //   _fertilizeFrequencyController.dispose();
  //   super.dispose();
  // }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _saveFormData();
      Navigator.of(context).pop(_formData);
    }
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
                //controller: _nameController,
                decoration: InputDecoration(labelText: 'Name *'),
                onSaved: (value) {
                  _formData.updateName(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },

              ),
              TextFormField(
                //controller: _idController,
                decoration: InputDecoration(labelText: 'ID (Scientific name) *'),
                onSaved: (value) {
                  _formData.updateId(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an ID';
                  }
                  return null;
                },

              ),
              TextFormField(
                //controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description *'),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                onSaved: (value) {
                  _formData.updateDescription(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },

              ),
              TextFormField(
                //controller: _careInstructionsController,
                decoration: InputDecoration(labelText: 'Care Instructions *'),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                onSaved: (value) {
                  _formData.updateCareInstructions(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter care instructions';
                  }
                },
              ),
              TextFormField(
                //controller: _lastWateredController,
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
                      _formData.updateLastWatered(date);
                    });
                  }
                },
              ),
              if (_formData.lastWatered != null) Text('Selected date: ${DateFormat('MM/dd/yyyy').format(_formData.lastWatered!)}'),
              TextFormField(
                //controller: _waterFrequencyController,
                decoration: InputDecoration(labelText: 'Watering Frequency (days) *'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onSaved: (value) {
                  // made 7 the default value for watering plants if user doesn't enter anything
                  _formData.updateWaterFrequency(int.tryParse(value ?? '7') ?? 7);
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
                //controller: _lastSoilChangeController,
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
                      _formData.updateLastSoilChange(date);
                    });
                  }
                },
              ),
              if (_formData.lastSoilChange != null) Text('Selected date: ${DateFormat('MM/dd/yyyy').format(_formData.lastSoilChange!)}'),
              TextFormField(
                //controller: _soilFrequencyController,
                decoration: InputDecoration(labelText: 'Soil Change Frequency (days)'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onSaved: (value) {
                  _formData.updateSoilChangeFrequency(value == null || value.isEmpty
                  ? null
                  :int.tryParse(value ?? '0'));
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
                //controller: _lastFertilizedController,
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
                      _formData.updateLastFertilized(date);
                    });
                  }
                },
              ),
              if (_formData.lastFertilized != null) Text('Selected date: ${DateFormat('MM/dd/yyyy').format(_formData.lastFertilized!)}'),
              TextFormField(
                //controller: _fertilizeFrequencyController,
                decoration: InputDecoration(labelText: 'Fertilizing Frequency (days)'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onSaved: (value) {
                  _formData.updateFertilizeFrequency(value == null || value.isEmpty
                  ? null
                  :int.tryParse(value ?? '0'));
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