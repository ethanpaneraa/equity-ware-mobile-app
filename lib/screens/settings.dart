import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, bool> trackingOptions = {
    'Footsteps': true,
    'Running': false,
    'Vehicle': true,
    'Keys': false,
    'Rustling': false,
  };

  String locationFrequency = 'Every Minute';

  final List<String> frequencyOptions = [
    'Every Second',
    'Every Minute',
    'Every 5 Minutes',
    'Every 10 Minutes',
    'Every 30 Minutes',
    'Every Hour',
  ];

  void _toggleTrackingOption(String key) {
    setState(() {
      trackingOptions[key] = !trackingOptions[key]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Settings', style:TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(69, 103, 81, 1.0)
      ),
      body: ListView(
        children: [
          ...trackingOptions.keys.map((String key) {
            return SwitchListTile(
              title: Text(key),
              value: trackingOptions[key]!,
              onChanged: (bool value) {
                _toggleTrackingOption(key);
              },
              activeColor: Color.fromRGBO(69, 103, 81, 1.0),
              activeTrackColor: Color.fromRGBO(69, 103, 81, 0.5)
            );
          }).toList(),
          Divider(),
          ListTile(
            title: Text('Location Update Frequency'),
            trailing: DropdownButton<String>(
              value: locationFrequency,
              onChanged: (String? newValue) {
                setState(() {
                  locationFrequency = newValue!;
                });
              },
              items: frequencyOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
