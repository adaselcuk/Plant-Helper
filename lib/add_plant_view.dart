import 'package:flutter/material.dart';
import 'plant.dart';

class AddPlantView extends StatefulWidget {
  final Function(Plant) addPlant;
  @override
  _AddPlantViewState createState() => _AddPLantViewState();
}

class _AddPlantViewState extends State<AddPlantView> {
  final _formKey = GlobalKey<FormState>();
  Plant newPlant = Plant(
    name: '',
    id: '',
    description: '',
    careInstructions: '',
    lastWatered: DateTime.now(),
    waterFrequency: 7,);
    // initialized plant with default values

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Plant'),
      ), 
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
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

          ])
        )
    )
  }
  
}