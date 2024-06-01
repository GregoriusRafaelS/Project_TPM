import 'package:flutter/material.dart';

class AdditionalFeaturesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                  Navigator.pushNamed(context, '/time_conversion');
              },
              child: Text('Konversi Waktu'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/curency_conversion');
              },
              child: Text('Konversi Uang'),
            ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/feedback');
                },
                child: Text('Pesan  & Kesan'),
            ),
          ],
        ),
      ),
    );
  }
}
