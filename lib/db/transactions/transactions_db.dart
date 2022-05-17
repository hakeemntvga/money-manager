import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/home/screen_home.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transactons/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transaction-db';

abstract class TransactionDBFunctions {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getAllTransaction();
  Future<void> deleteTransaction(String id);
  Future<Map<String, double>> getTotal();
}

class TransactionDB implements TransactionDBFunctions {
  TransactionDB.internal();
  static TransactionDB instance = TransactionDB.internal();
  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier =

      ValueNotifier([]);

       ValueNotifier<Map<String, double>> overviewDataNotifier = ValueNotifier(
    {
      "totalIncome": 0,
      "totalExpense": 0,
      "totalBalnce": 0,
    },
  );

    // final  ValueNotifier<double> incomeTotalNotifier = ValueNotifier(0);
    //   ValueNotifier<double> expenseTotalxpenseNotifier = ValueNotifier(0);
    //   ValueNotifier<double> totalAmountNotifier = ValueNotifier(0);
     

 // ValueNotifier<List<TransactionModel>> incomeListNotifier = ValueNotifier([]);
  // ValueNotifier<List<TransactionModel>> expenseListNotifier = ValueNotifier([]);
  // ValueNotifier<List<TransactionModel>> totalBalanceListNotifier = ValueNotifier([]);
  // double incomeTotal = 0;
  // double expenseTotal = 0;
  // double totalBalance = 0;

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.put(obj.id, obj);
  }

  Future<void> refresh() async {
    final _list = await getAllTransaction();
    _list.sort(
      (first, second) => second.date.compareTo(first.date),
    );
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(_list);
    transactionListNotifier.notifyListeners();


    final _overviewData = await getTotal();
    overviewDataNotifier.value.clear();
    overviewDataNotifier.value = _overviewData;
    print(overviewDataNotifier.value);
    overviewDataNotifier.notifyListeners();
  }

  // Future<void> totalIncomeAndExpense() async {
  //   final _income = await getAllTransaction();
  //   print(_income[0]);
  //   incomeTotal = 0;
  //   expenseTotal = 0;
  //   totalBalance = 0;
  //  for (var category in _income) {
  //       if (category.type == CategoryType.income) {
  //         incomeTotal = incomeTotal + category.amount;
  //       } else {
  //         expenseTotal = expenseTotal + category.amount;
  //       }
  //     }totalBalance=incomeTotal -= expenseTotal;

   
  // }

  @override
  Future<List<TransactionModel>> getAllTransaction() async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return _db.values.toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.delete(id);
    refresh();
  }

 @override
  Future<Map<String, double>> getTotal() async {
    Map<String, double> _data = {
      "totalIncome": 0,
      "totalExpense": 0,
      "totalBalance": 0
    };
    final _transactions = await getAllTransaction();

    _transactions.forEach((TransactionModel _transaction) {
      if (_transaction.type == CategoryType.income) {
        _data["totalIncome"] = _data["totalIncome"]! + _transaction.amount;
      } else if (_transaction.type == CategoryType.exoense) {
        _data["totalExpense"] = _data['totalExpense']! + _transaction.amount;
      }
    });

    _data['totalBalance'] = _data['totalIncome']! - _data['totalExpense']!;
    return _data;
  }
}
