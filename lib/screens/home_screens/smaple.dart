import 'package:flutter/material.dart';

class FreightCalculatorScreen extends StatefulWidget {
  @override
  _FreightCalculatorScreenState createState() => _FreightCalculatorScreenState();
}

class _FreightCalculatorScreenState extends State<FreightCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final _dispatchedMilesController = TextEditingController();
  final _estimatedTollsController = TextEditingController();
  final _otherCostsController = TextEditingController();
  final _freightChargeController = TextEditingController();

  double _mileageFeePerMile = 0.075;
  double _fuelCostPerMile = 0.58;
  double _defCostPerMile = 0.04;
  double _driverPayPerMile = 0.6;
  double _factoringFeeRate = 0.05;

  double _totalCostPerWeek = 0.0;

  void _calculateCosts() {
    if (_formKey.currentState!.validate()) {
      final dispatchedMiles = double.parse(_dispatchedMilesController.text);
      final estimatedTolls = double.parse(_estimatedTollsController.text);
      final otherCosts = double.parse(_otherCostsController.text);
      final freightCharge = double.parse(_freightChargeController.text);

      final mileageFee = dispatchedMiles * _mileageFeePerMile;
      final fuelCost = dispatchedMiles * _fuelCostPerMile;
      final defCost = dispatchedMiles * _defCostPerMile;
      final driverPay = dispatchedMiles * _driverPayPerMile;
      final factoringFee = freightCharge * _factoringFeeRate;

      final totalCostPerWeek = mileageFee + fuelCost + defCost + driverPay + estimatedTolls + otherCosts + factoringFee;

      setState(() {
        _totalCostPerWeek = totalCostPerWeek;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Freight Calculator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _freightChargeController,
                  decoration: InputDecoration(labelText: 'Freight Charge'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter freight charge';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _dispatchedMilesController,
                  decoration: InputDecoration(labelText: 'Dispatched Miles'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter dispatched miles';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _estimatedTollsController,
                  decoration: InputDecoration(labelText: 'Estimated Tolls'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter estimated tolls';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _otherCostsController,
                  decoration: InputDecoration(labelText: 'Other Costs'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter other costs';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateCosts,
                  child: Text('Calculate Costs'),
                ),
                SizedBox(height: 20),
                Text(
                  'Total Cost Per Week: \$${_totalCostPerWeek.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
