import 'package:flutter/material.dart';
import 'package:money_manager/category/screen_category.dart';

import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transactions/transactions_db.dart';
import 'package:money_manager/home/widgets/bottom_navigation.dart';
import 'package:money_manager/models/category/category_add_pop_up.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/screens/add_transaction/screen_add_transaction.dart';
import 'package:money_manager/transactions/screen_transaction.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  static ValueNotifier<double> incomeTotalNotifier = ValueNotifier(0);
  static ValueNotifier<double> expenseTotalxpenseNotifier = ValueNotifier(0);
  static ValueNotifier<double> totalAmountNotifier = ValueNotifier(0);

  final _pages = const [
    ScreenTransaction(),
    ScreenCategory(),
  ];

  @override
  Widget build(BuildContext context) {
     //TransactionDB.instance.refresh();
    TransactionDB.instance.getTotal();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 230, 230),
      appBar: AppBar(
        //leading: Text("data"),
        title: const Text(
          "MONEY MANAGER",
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const MoneyManagerBottomNavigation(),
      body: Column(
        //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    ValueListenableBuilder(
                        valueListenable: incomeTotalNotifier,
                        builder: (BuildContext context, double updatedIncome,
                            Widget? _) {
                          return 
                          Column(
                            children: [
                              const Text('Income'),
                              const Divider(
                                height: 10.0,
                              ),
                              Text(updatedIncome.toString()),
                            ],
                          );
                        },),
                  ],
                ),
                ValueListenableBuilder(
                    valueListenable:expenseTotalxpenseNotifier,
                    builder: (BuildContext context, double updatedExpense,
                        Widget? _) {
                      return
                       Column(
                        children: [
                          const Text("Expense"),
                          const Divider(
                            height: 10.0,
                          ),
                          Text(updatedExpense.toString()),
                        ],
                      );
                    },),
                ValueListenableBuilder(
                    valueListenable:totalAmountNotifier,
                    builder:
                        (BuildContext context, double updateTotal, Widget? _) {
                      return Column(
                        children: [
                          const Text("Total"),
                          const Divider(
                            height: 10.0,
                          ),
                          Text(updateTotal.toString()),
                        ],
                      );
                    }),
              ],
            ),
          ),
          Expanded(
            child: SafeArea(
              child: ValueListenableBuilder(
                valueListenable: selectedIndexNotifier,
                builder: (BuildContext context, int updatedIndex, Widget? _) {
                  return _pages[updatedIndex];
                },
              ),
            )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndexNotifier.value == 0) {
            Navigator.of(context).pushNamed(ScreenAddTransaction.routName);
          } else {
            ShowCategoryAddPopup(context);
            // final _sample = CategoryModel(
            //   id: DateTime.now().microsecondsSinceEpoch.toString(),
            //   name: "Travel",
            //   type: CategoryType.exoense,
            // );
            // CategoryDB().insertCategory(_sample);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
