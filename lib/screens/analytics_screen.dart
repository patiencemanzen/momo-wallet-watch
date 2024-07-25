import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
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
            color: const Color.fromARGB(255, 89, 115, 166),
            child: const Center(
              child: Text(
                "Analytics Screen",
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
