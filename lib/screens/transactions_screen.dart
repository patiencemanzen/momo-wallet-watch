import 'package:flutter/material.dart';
import '../services/transaction_service.dart';
import '../models/transaction.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final TransactionService transactionService = TransactionService();
  final TextEditingController _phoneNumberController = TextEditingController();

  List<Transaction>? _transactions;
  bool _isLoading = false;
  String? _error;

  void _fetchTransactions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final transactions = await transactionService
          .getTransactionsByNumber(_phoneNumberController.text);

      setState(() {
        _transactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Enter Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchTransactions,
              child: const Text('Fetch Transactions'),
            ),
            if (_isLoading) const CircularProgressIndicator(),
            if (_error != null)
              Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            if (_transactions != null)
              Expanded(
                child: ListView.builder(
                  itemCount: _transactions!.length,
                  itemBuilder: (context, index) {
                    final transaction = _transactions![index];
                    return ListTile(
                      title: Text('Transaction: ${transaction.id}'),
                      subtitle: Text(
                          'Amount: ${transaction.amount} ${transaction.currency}'),
                      trailing: Text('Status: ${transaction.status}'),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
