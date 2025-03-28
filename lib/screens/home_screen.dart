// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_watcher/components/tab_item.dart';
import 'package:wallet_watcher/components/circular_bottom_navigation.dart';
import 'package:wallet_watcher/screens/analytics_screen.dart';
import 'package:wallet_watcher/screens/budgeting_screen.dart';
import 'package:wallet_watcher/screens/expenses_screen.dart';
import 'package:wallet_watcher/screens/goals_screen.dart';
import 'package:wallet_watcher/screens/login_screen.dart';
import 'package:wallet_watcher/services/auth_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    this.title,
  });
  final String? title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedPos = 0;

  double bottomNavBarHeight = 60;

  List<TabItem> tabItems = List.of([
    TabItem(
      Icons.home,
      "Home",
      Colors.blue,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.normal,
      ),
    ),
    TabItem(
      Icons.pie_chart,
      "Budget",
      Colors.orange,
      labelStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    TabItem(
      Icons.receipt,
      "Expenses",
      Colors.red,
      circleStrokeColor: Colors.black,
    ),
    TabItem(
      Icons.flag,
      "Goals",
      Colors.cyan,
    ),
  ]);

  late CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(selectedPos);
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "Home",
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 19)),
        backgroundColor: const Color.fromARGB(255, 3, 143, 141),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            color: Colors.white,
            onPressed: () {
              // Handle profile icon press
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            color: Colors.white,
            onPressed: () {
              // Handle settings icon press
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: () async {
              await authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: bottomNavBarHeight),
            child: bodyContainer(),
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomNav())
        ],
      ),
    );
  }

  Widget bodyContainer() {
    Widget screen = const Placeholder();

    switch (selectedPos) {
      case 0:
        screen = const AnalyticsScreen();
        break;
      case 1:
        screen = BudgetScreen();
        break;
      case 2:
        screen = ExpenseScreen();
        break;
      case 3:
        screen = GoalScreen();
        break;
    }

    return screen;
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      selectedPos: selectedPos,
      barHeight: bottomNavBarHeight,
      // use either barBackgroundColor or barBackgroundGradient to have a gradient on bar background
      barBackgroundColor: Colors.white,
      // barBackgroundGradient: LinearGradient(
      //   begin: Alignment.bottomCenter,
      //   end: Alignment.topCenter,
      //   colors: [
      //     Colors.blue,
      //     Colors.red,
      //   ],
      // ),
      backgroundBoxShadow: const <BoxShadow>[
        BoxShadow(color: Colors.black45, blurRadius: 10.0),
      ],
      animationDuration: const Duration(milliseconds: 300),
      selectedCallback: (int? selectedPos) {
        setState(() {
          this.selectedPos = selectedPos ?? 0;
          print(_navigationController.value);
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }
}
