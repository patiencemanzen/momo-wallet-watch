import 'package:flutter/material.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
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
            color: const Color.fromARGB(255, 56, 50, 42),
            child: const Center(
              child: Text(
                "Expenses Screen",
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
