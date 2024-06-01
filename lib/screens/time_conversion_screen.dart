import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeConversionScreen extends StatefulWidget {
  @override
  _TimeConversionScreenState createState() => _TimeConversionScreenState();
}

class _TimeConversionScreenState extends State<TimeConversionScreen> {
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedTimeZone = 'WIB';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Conversion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (picked != null && picked != selectedTime) {
                    setState(() {
                      selectedTime = picked;
                    });
                  }
                },
                child: Text('Select Time'),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: DropdownButton<String>(
                value: selectedTimeZone,
                items: <String>['WIB', 'WITA', 'WIT', 'London'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTimeZone = newValue!;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Selected Time: ${selectedTime.format(context)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Converted Time: ${_convertTime(selectedTime, selectedTimeZone)}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  String _convertTime(TimeOfDay time, String timeZone) {
    DateTime now = DateTime.now();
    DateTime localTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    DateFormat dateFormat = DateFormat('HH:mm');

    switch (timeZone) {
      case 'WIB':
        return dateFormat.format(localTime);
      case 'WITA':
        return dateFormat.format(localTime.add(Duration(hours: 1)));
      case 'WIT':
        return dateFormat.format(localTime.add(Duration(hours: 2)));
      case 'London':
        return dateFormat.format(localTime.subtract(Duration(hours: 7)));
      default:
        return dateFormat.format(localTime);
    }
  }
}
