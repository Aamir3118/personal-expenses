import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/providers/my_transaction.dart';
import 'package:provider/provider.dart';

import './chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatefulWidget {
  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  //final List<Transaction> recentTransactions;
  final dynamic recentTransactions = null;

  @override
  Widget build(BuildContext context) {
    final groupedTransactionValues =
        Provider.of<MyTransaction>(context, listen: false)
            .groupedTransactionValues;
    final totalSpendingGetter =
        Provider.of<MyTransaction>(context, listen: false).totalSpending;
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'].toString(),
                data['amount'] as double,
                totalSpendingGetter == 0.0
                    ? 0.0
                    : (data['amount'] as double) / totalSpendingGetter,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
