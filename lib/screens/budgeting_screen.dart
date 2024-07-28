import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:momo_wallet_watcher/services/budget_service.dart';
import 'package:momo_wallet_watcher/models/budget.dart';
import 'package:intl/intl.dart';

class BudgetScreen extends StatelessWidget {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final budgetService = Provider.of<BudgetService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Budgets')),
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
                  TextFormField(
                    controller: startDateController,
                    decoration: const InputDecoration(labelText: 'Start Date'),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('MM/dd/yyyy').format(pickedDate);
                        startDateController.text = formattedDate;
                      }
                    },
                  ),
                  TextFormField(
                    controller: endDateController,
                    decoration: const InputDecoration(labelText: 'End Date'),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('MM/dd/yyyy').format(pickedDate);
                        endDateController.text = formattedDate;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final DateFormat inputFormat = DateFormat('MM/dd/yyyy');
                        final DateTime startDate =
                            inputFormat.parse(startDateController.text);
                        final DateTime endDate =
                            inputFormat.parse(endDateController.text);

                        final budget = Budget(
                          id: '',
                          category: categoryController.text,
                          amount: double.parse(amountController.text),
                          startDate: startDate,
                          endDate: endDate,
                        );
                        budgetService.addBudget(budget);
                      }
                    },
                    child: const Text('Add Budget'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Budget>>(
              stream: budgetService.getBudgets(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final budgets = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: budgets.length,
                  itemBuilder: (context, index) {
                    final budget = budgets[index];
                    return ListTile(
                      title: Text(budget.category),
                      subtitle: Text('\$${budget.amount.toStringAsFixed(2)}'),
                      trailing: Text(
                          '${budget.startDate.toLocal()} - ${budget.endDate.toLocal()}'),
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
