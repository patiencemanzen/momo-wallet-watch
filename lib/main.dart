import 'package:flutter/material.dart';
import 'package:momo_wallet_watcher/screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const WalletWatcher());
}

class WalletWatcher extends StatelessWidget {
  const WalletWatcher({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Momo Wallet Watcher',
      home: MyHomePage(title: 'Momo Wallet Watcher'),
    );
  }
}
