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
        backgroundColor: Color.fromARGB(255, 29, 31, 43),
        title: const Text(
          
          "MONEY MANAGER",
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const MoneyManagerBottomNavigation(),
      body: Column(
        //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: SafeArea(
            child: ValueListenableBuilder(
              valueListenable: selectedIndexNotifier,
              builder: (BuildContext context, int updatedIndex, Widget? _) {
                return _pages[updatedIndex];
              },
            ),
          )),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        
        backgroundColor: Color.fromARGB(255, 29, 31, 43),
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
