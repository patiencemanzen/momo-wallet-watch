import 'package:flutter/material.dart';
import 'package:momo_wallet_watcher/screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:momo_wallet_watcher/services/budget_service.dart';
import 'package:momo_wallet_watcher/services/expense_service.dart';
import 'package:momo_wallet_watcher/services/goal_service.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const WalletWatcher());
}

class WalletWatcher extends StatelessWidget {
  const WalletWatcher({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<BudgetService>(create: (_) => BudgetService()),
        Provider<GoalService>(create: (_) => GoalService()),
        Provider<ExpenseService>(create: (_) => ExpenseService()),
      ],
      child: MaterialApp(
        title: 'Flutter App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(
          title: "Momo Wallet Watcher",
        ),
      ),
    );
  }
}
