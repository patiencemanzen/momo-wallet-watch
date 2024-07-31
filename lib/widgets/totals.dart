import 'package:flutter/material.dart';
import 'package:momo_wallet_watcher/models/budget.dart';
import 'package:momo_wallet_watcher/models/expense.dart';
import 'package:momo_wallet_watcher/models/goal.dart';
import 'package:momo_wallet_watcher/services/analytics_service.dart';
import 'package:momo_wallet_watcher/utils/analytics.dart';
import 'package:provider/provider.dart';

class TotalsScreen extends StatelessWidget {
  const TotalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final analyticsService = Provider.of<AnalyticsService>(context);
    final analytics = Analytics();

    return FutureBuilder(
      future: Future.wait([
        analyticsService.getExpenses(),
        analyticsService.getBudgets(),
        analyticsService.getGoals(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final expenses = snapshot.data?[0] as List<Expense>;
        final budgets = snapshot.data?[1] as List<Budget>;
        final goals = snapshot.data?[2] as List<Goal>;

        final totalExpenses = analytics.calculateTotalExpenses(expenses);
        final totalBudgets = analytics.calculateTotalBudgets(budgets);
        final totalGoalsSaved = analytics.calculateTotalGoalsSaved(goals);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Expenses: \$${totalExpenses.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20)),
                Text('Total Budgets: \$${totalBudgets.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20)),
                Text(
                    'Total Goals Saved: \$${totalGoalsSaved.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
        );
      },
    );
  }
}
