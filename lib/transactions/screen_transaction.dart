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

    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
        return ListView.separated(
          padding: const EdgeInsets.all(10.0),
          itemBuilder: (ctx, index) {
            final _value = newList[index];
            return Slidable(
              key: Key(_value.id!),
              startActionPane: ActionPane(
                motion: DrawerMotion(),
                children: [
                  SlidableAction(
                    foregroundColor: Colors.red,
                    onPressed: (ctx) {
                      TransactionDB.instance.deleteTransaction(_value.id!);
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
                          ? Color.fromARGB(255, 4, 255, 12)
                          : Colors.red,
                    ),
                  ),
                  subtitle: Text(_value.category.name),
                  trailing: Icon(
                    _value.type == CategoryType.income
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: (_value.type == CategoryType.income
                        ? Colors.green
                        : Colors.red),
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
        );
      },
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitDate = _date.split(' ');
    return '${_splitDate.last}   ${_splitDate.first}';
    // return "${date.day} ${date.month}";
  }
}
