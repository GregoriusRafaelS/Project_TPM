import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyConversionScreen extends StatefulWidget {
  @override
  _CurrencyConversionScreenState createState() => _CurrencyConversionScreenState();
}

class _CurrencyConversionScreenState extends State<CurrencyConversionScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'IDR';
  double _convertedAmount = 0.0;
  String _errorMessage = '';

  Future<void> _convertCurrency() async {
    final amountText = _amountController.text;
    if (amountText.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an amount';
      });
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null) {
      setState(() {
        _errorMessage = 'Invalid amount';
      });
      return;
    }

    setState(() {
      _errorMessage = '';
    });

    final response = await http.get(Uri.parse('https://v6.exchangerate-api.com/v6/1dec9d24fe68f9e4644bac44/latest/$_fromCurrency'));

    if (response.statusCode == 200) {
      final rates = jsonDecode(response.body)['conversion_rates'];
      setState(() {
        _convertedAmount = amount * rates[_toCurrency];
      });
    } else {
      setState(() {
        _errorMessage = 'Failed to load exchange rate';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Conversion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                errorText: _errorMessage.isEmpty ? null : _errorMessage,
              ),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _fromCurrency,
              items: <String>['USD', 'EUR', 'JPY', 'IDR'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _fromCurrency = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _toCurrency,
              items: <String>['USD', 'EUR', 'JPY', 'IDR'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _toCurrency = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertCurrency,
              child: Text('Convert'),
            ),
            SizedBox(height: 20),
            Text(
              'Converted Amount: $_convertedAmount $_toCurrency',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
