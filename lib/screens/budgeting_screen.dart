import 'package:flutter/material.dart';

class BudgetingScreen extends StatefulWidget {
  const BudgetingScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BudgetingScreenState createState() => _BudgetingScreenState();
}

class _BudgetingScreenState extends State<BudgetingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.orange,
            child: const Center(
              child: Text(
                "Budgeting Screen",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
