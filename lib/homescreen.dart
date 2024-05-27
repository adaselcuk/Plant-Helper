import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'add_plant_view.dart';
import 'plant_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List> _events = {};
  List<dynamic> _selectedEvents = [];

  void generateEvents(int wateringFrequency, int fertilizingFrequency, int soilChangeFrequency) {
    DateTime now = DateTime.now();
    DateTime endOfMonth= DateTime(now.year, now.month + 1, 0);

    for (int i = 0; i <= endOfMonth.day; i++) {
      DateTime day = DateTime(now.year, now.month, i);

      List<String> events = [];

      if (i % wateringFrequency == 0) {
        events.add('watering');
      }
      if (i % fertilizingFrequency == 0) {
        events.add('fertilizing');
      }
      if (i % soilChangeFrequency == 0) {
        events.add('soil change');
      }

      if (events.isNotEmpty) {
        _events[day] = events;
      }
    }

    setState(() {
      _events = _events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar View'),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2035, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (_events[selectedDay] == null || _events[selectedDay]!.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('No events for this day')),
            );
          }
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _selectedEvents = _events[selectedDay] ?? [];
          });
        },
        eventLoader: (day) {
          return _events[day] ?? [];
        },
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isNotEmpty) {
              return Positioned(
                bottom: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: events.map<Widget>((event) {
                    if (event == 'watering') {
                      return Icon(Icons.opacity, size: 20.0);
                    } else if (event == 'fertilizing') {
                      return Icon(Icons.eco, size: 20.0);
                    } else if (event == 'soil change') {
                      return Icon(Icons.grass, size: 20.0);
                    } else{
                      return Container();
                    }
                  }).toList(),
                ),
              );
            }
            return Container();
          },
        ),
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPlantView(addPlant: (plant) {
                Provider.of<PlantList>(context, listen: false).addPlant(plant);
                int waterFrequency = plant.waterFrequency ?? 7;
                int fertilizeFrequency = plant.fertilizeFrequency ?? 30;
                int soilChangeFrequency = plant.soilFrequency ?? 365;
                generateEvents(waterFrequency, fertilizeFrequency, soilChangeFrequency);
                Navigator.pop(context);
              }
              )),
            );
        },
        child: Icon(Icons.add),
      ),
      ),
    );
  }
}