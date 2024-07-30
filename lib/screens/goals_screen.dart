import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/goal_service.dart';
import '../models/goal.dart';
import 'package:intl/intl.dart';

class GoalScreen extends StatelessWidget {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController targetAmountController = TextEditingController();
  final TextEditingController targetDateController = TextEditingController();
  final TextEditingController savedAmountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goalService = Provider.of<GoalService>(context);

    return Scaffold(
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: targetAmountController,
                    decoration: InputDecoration(labelText: 'Target Amount'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a target amount';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: targetDateController,
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
                        targetDateController.text = formattedDate;
                      }
                    },
                  ),
                  TextFormField(
                    controller: savedAmountController,
                    decoration: InputDecoration(labelText: 'Saved Amount'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a saved amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final DateFormat inputFormat = DateFormat('MM/dd/yyyy');
                        final DateTime targetDate =
                            inputFormat.parse(targetDateController.text);

                        final goal = Goal(
                          id: '',
                          description: descriptionController.text,
                          targetAmount:
                              double.parse(targetAmountController.text),
                          targetDate: targetDate,
                          savedAmount: double.parse(savedAmountController.text),
                        );

                        goalService.addGoal(goal);
                      }
                    },
                    child: const Text('Add Goal'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Goal>>(
              stream: goalService.getGoals(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final goals = snapshot.data ?? [];
                final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

                return ListView.builder(
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    return Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ListTile(
                          title: Text(
                            goal.description,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Target: \$${goal.targetAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                'Saved: \$${goal.savedAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          trailing: Text(
                            'Target Date: ${dateFormat.format(goal.targetDate)}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
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
