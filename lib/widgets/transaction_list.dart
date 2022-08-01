import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/providers/my_transaction.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  //final List<Transaction> transactions;
  //final Function deleteTx;

  //TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    //final myTransaction = Provider.of<MyTransaction>(context, listen: false);

    return FutureBuilder(
        future: Provider.of<MyTransaction>(context).fetchAndSetTransactions(),
        builder: (ctx, snapshot) => Consumer<MyTransaction>(
              builder: (ctx, myTransaction, ch) => ListView.builder(
                itemCount: myTransaction.items.length,
                itemBuilder: (ctx, index) => (myTransaction.items.length <= 0
                    ? Center(child: Text("No data"))
                    : Card(
                        elevation: 5,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.purple,
                            radius: 30,
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: FittedBox(
                                child: Text(
                                  '\u{20B9}${myTransaction.items[index].amount.toStringAsFixed(0)}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            myTransaction.items[index].title,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(DateFormat.yMMMd()
                              .format(myTransaction.items[index].date)),
                          trailing: MediaQuery.of(context).size.width > 360
                              ? FlatButton.icon(
                                  icon: Icon(Icons.delete),
                                  label: Text("Delete"),
                                  textColor: Theme.of(context).errorColor,
                                  onPressed: () {
                                    Provider.of<MyTransaction>(context,
                                            listen: false)
                                        .deleteTransaction(
                                            myTransaction.items[index].id);
                                    //widget.deleteTx(widget.transaction.id);
                                  },
                                )
                              : IconButton(
                                  color: Theme.of(context).errorColor,
                                  onPressed: () {
                                    Provider.of<MyTransaction>(context,
                                            listen: false)
                                        .deleteTransaction(
                                            myTransaction.items[index].id);
                                    // widget.deleteTx(widget.transaction.id);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                  )),
                        ),
                      )),
              ),
            ));
  }
}

class TransactionListItem extends StatefulWidget {
  const TransactionListItem({
    required this.transaction,
  });

  final Transaction transaction;

  @override
  State<TransactionListItem> createState() => _TransactionListItemState();
}

class _TransactionListItemState extends State<TransactionListItem> {
  Color? _bgColor;
  @override
  void initState() {
    const availableColors = [
      Colors.red,
      Colors.brown,
      Colors.accents,
      Colors.blue,
    ];
    _bgColor = availableColors[Random().nextInt(4)] as Color?;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
              child: Text(
                '\u{20B9}${widget.transaction.amount.toStringAsFixed(0)}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(DateFormat.yMMMd().format(widget.transaction.date)),
        trailing: MediaQuery.of(context).size.width > 360
            ? FlatButton.icon(
                icon: Icon(Icons.delete),
                label: Text("Delete"),
                textColor: Theme.of(context).errorColor,
                onPressed: () {
                  //widget.deleteTx(widget.transaction.id);
                },
              )
            : IconButton(
                color: Theme.of(context).errorColor,
                onPressed: () {
                  // widget.deleteTx(widget.transaction.id);
                },
                icon: Icon(
                  Icons.delete,
                )),
      ),
    );
  }
}
