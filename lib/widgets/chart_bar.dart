import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraint) {
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
                  return Column(
                    children: <Widget>[
                      Container(
                        height: constraint.maxHeight * 0.15,
                        child: FittedBox(
                          child: Text(
                              '\u{20B9}${_myTransactions[index]['amount']}'),
                        ),
                      ),
                      SizedBox(
                        height: constraint.maxHeight * 0.05,
                      ),
                      Container(
                        height: constraint.maxHeight * 0.6,
                        width: 10,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1.0),
                                color: Color.fromRGBO(220, 220, 220, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            FractionallySizedBox(
                              heightFactor: spendingPctOfTotal,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: constraint.maxHeight * 0.05,
                      ),
                      Container(
                          height: constraint.maxHeight * 0.15,
                          child: FittedBox(child: Text(label))),
                    ],
                  );
                });
          });
    });
  }
}
