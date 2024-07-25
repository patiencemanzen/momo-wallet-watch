import 'package:flutter/material.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
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
            color: const Color.fromARGB(255, 54, 42, 56),
            child: const Center(
              child: Text(
                "Goals Screen",
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
