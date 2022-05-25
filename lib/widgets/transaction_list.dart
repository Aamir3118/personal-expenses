import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart' as t;

class TransactionList extends StatelessWidget {
  final List<t.Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('expenses').snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final _myTransactions = streamSnapshot.data!.docs;
          return ListView.builder(
              itemCount: _myTransactions.length,
              itemBuilder: (ctx, index) {
                /*transactions.isEmpty
                    ? Column(
                        children: <Widget>[
                          Text(
                            "No Transactions added yet!",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              height: 200,
                              child: Image.asset(
                                'assets/images/waiting.png',
                                fit: BoxFit.cover,
                              ))
                        ],
                      )
                    : Container();
    */
                return _myTransactions.isEmpty
                    ? Column(
                        children: <Widget>[
                          Text(
                            "No Transactions added yet!",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              height: 200,
                              child: Image.asset(
                                'assets/images/waiting.png',
                                fit: BoxFit.cover,
                              ))
                        ],
                      )
                    : Card(
                        elevation: 5,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            child: Padding(
                                padding: EdgeInsets.all(6),
                                child: FittedBox(
                                    child: Text(
                                        '\u{20B9}${_myTransactions[index]['amount']}'))),
                          ),
                          title: Text(
                            _myTransactions[index]['title'],
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text('${_myTransactions[index]['date']}'),
                          trailing: IconButton(
                              color: Theme.of(context).errorColor,
                              onPressed: () {
                                deleteTx(_myTransactions[index]['id']);
                              },
                              icon: Icon(
                                Icons.delete,
                              )),
                        ),
                      );
              });
        });
    /*
    transactions.isEmpty
        ? Column(
            children: <Widget>[
              Text(
                "No Transactions added yet!",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: 200,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ))
            ],
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text(
                            '\u{20B9}${transactions[index].amount.toStringAsFixed(0)}'),
                      ),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle:
                      Text(DateFormat.yMMMd().format(transactions[index].date)),
                  trailing: IconButton(
                      color: Theme.of(context).errorColor,
                      onPressed: () {
                        deleteTx(transactions[index].id);
                      },
                      icon: Icon(
                        Icons.delete,
                      )),
                ),
              );
            },
            itemCount: transactions.length,
          );
 */
  }
}
