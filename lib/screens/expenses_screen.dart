import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/expense_service.dart';
import '../models/expense.dart';

class ExpenseScreen extends StatelessWidget {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseService = Provider.of<ExpenseService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Expenses')),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: categoryController,
                    decoration: const InputDecoration(labelText: 'Category'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a category';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final expense = Expense(
                          id: '',
                          category: categoryController.text,
                          amount: double.parse(amountController.text),
                          date: DateTime.now(),
                        );
                        expenseService.addExpense(expense);
                      }
                    },
                    child: const Text('Add Expense'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Expense>>(
              stream: expenseService.getExpenses(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final expenses = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return ListTile(
                      title: Text(expense.category),
                      subtitle: Text('\$${expense.amount.toStringAsFixed(2)}'),
                      trailing: Text(expense.date.toLocal().toString()),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
