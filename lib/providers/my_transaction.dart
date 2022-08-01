import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/helpers/db_helper.dart';
import 'package:personal_expenses/models/transaction.dart';

class MyTransaction with ChangeNotifier {
  List<Transaction> _items = [];

  List<Transaction> get items {
    return [..._items];
  }

  DBHelper dbh = DBHelper();

  void addTransaction(String id, String title, double amount, DateTime date) {
    final newTransaction = Transaction(
      id: id,
      title: title,
      amount: amount,
      date: date,
    );
    _items.add(newTransaction);
    notifyListeners();
    DBHelper.insert('my_transaction', {
      'id': newTransaction.id,
      'title': newTransaction.title,
      'amount': newTransaction.amount,
      'date': newTransaction.date.toString(),
    });
  }

  Future<void> fetchAndSetTransactions() async {
    final transList = await DBHelper.getData('my_transaction');
    _items = transList
        .map(
          (item) => Transaction(
            id: item['id'],
            title: item['title'],
            amount: double.parse(item['amount'].toString()),
            date: DateTime.parse(item['date']),
          ),
        )
        .toList();
    notifyListeners();
  }

  Future<int> deleteTransaction(String itemId) async {
    final result = await dbh.delete(itemId);
    notifyListeners();
    return result;
  }

  List<Map<String, dynamic>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for (var i = 0; i < _items.length; i++) {
        if (_items[i].date.day == weekDay.day &&
            _items[i].date.month == weekDay.month &&
            _items[i].date.year == weekDay.year) {
          totalSum += _items[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 3),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }
}
