import 'package:momo_wallet_watcher/models/budget.dart';
import 'package:momo_wallet_watcher/models/expense.dart';
import 'package:momo_wallet_watcher/models/goal.dart';

class Analytics {
  double calculateTotalExpenses(List<Expense> expenses) {
    return expenses.fold(0, (sum, item) => sum + item.amount);
  }

  double calculateTotalBudgets(List<Budget> budgets) {
    return budgets.fold(0, (sum, item) => sum + item.amount);
  }

  double calculateTotalGoalsSaved(List<Goal> goals) {
    return goals.fold(0, (sum, item) => sum + item.savedAmount);
  }
}
