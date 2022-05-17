import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transactions/transactions_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transactons/transaction_model.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refreshUI();

    return

        ///////

        ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.all(
                  12.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(24.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 8.0),
                    child: ValueListenableBuilder(
                      valueListenable:
                          TransactionDB.instance.overviewDataNotifier,
                      builder: (
                        BuildContext context,
                        Map<String, double> _overviewData,
                        Widget? _,
                      ) {
                        return Column(
                          children: [
                            const Text(
                              "Total Balance",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              _overviewData['totalBalance'].toString(),
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                Text(
                                  "Income",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "Expence",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  _overviewData['totalIncome'].toString(),
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  _overviewData['totalExpense'].toString(),
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Recent Transactions",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(10.0),
                itemBuilder: (ctx, index) {
                  final _value = newList[index];
                  return Slidable(
                    key: Key(_value.id!),
                    startActionPane: ActionPane(
                      motion: DrawerMotion(),
                      children: [
                        SlidableAction(
                          foregroundColor: Color.fromARGB(255, 209, 4, 4),
                          onPressed: (ctx) {
                            TransactionDB.instance
                                .deleteTransaction(_value.id!);
                          },
                          icon: Icons.delete,
                          label: "Delete",
                        )
                      ],
                    ),
                    child: Card(
                      child: ListTile(
                        leading: Text(
                          parseDate(_value.date),
                          textAlign: TextAlign.center,
                        ),
                        title: Text(
                          "QR.${_value.amount}",
                          style: TextStyle(
                            color: _value.type == CategoryType.income
                                ? Color.fromARGB(255, 40, 153, 6)
                                : Color.fromARGB(255, 222, 10, 35),
                          ),
                        ),
                        subtitle: Text(_value.category.name),
                        trailing: Icon(
                          _value.type == CategoryType.income
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: (_value.type == CategoryType.income
                              ? Color.fromARGB(255, 40, 153, 6)
                              : Color.fromARGB(255, 222, 10, 35)
                        ),
                      ),
                    ),
                    ),
                  );
                },
                separatorBuilder: (ctx, index) {
                  return const SizedBox(
                    height: 0.8,
                  );
                },
                itemCount: newList.length,
              ),
            ),
          ],
        );
      },
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitDate = _date.split(' ');
    return '${_splitDate.last}'" -"'  ${_splitDate.first}';
    // return "${date.day} ${date.month}";
  }
}
