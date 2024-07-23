import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../models/transaction.dart';

class TransactionChart extends StatelessWidget {
  final List<charts.Series<Transaction, String>> seriesList;
  final bool animate;

  const TransactionChart(this.seriesList, {super.key, this.animate = false});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
    );
  }
}

List<charts.Series<Transaction, String>> createSampleData(List<Transaction> transactions) {
  return [
    charts.Series<Transaction, String>(
      id: 'Transactions',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (Transaction tx, _) => tx.date,
      measureFn: (Transaction tx, _) => double.parse(tx.amount),
      data: transactions,
    )
  ];
}
