import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transactions/transactions_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transactons/transaction_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routName = 'add-transaction';

  const ScreenAddTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;
 
  String? _categoryID;

  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

 

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  /*
purpose
amount
Date
Category type
Income/Expense

  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Add Transactions",
              style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: _purposeTextEditingController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: "Purpose",
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextFormField(
              controller: _amountTextEditingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Amount",
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextButton.icon(
              onPressed: () async {
                final _selectedDateTemp = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(
                    const Duration(days: 30),
                  ),
                  lastDate: DateTime.now(),
                );
                if (_selectedDateTemp == null) {
                  return;
                } else {
                  print(_selectedDateTemp.toString());
                  setState(() {
                    _selectedDate = _selectedDateTemp;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _selectedDate == null
                    ? "Select Date"
                    : _selectedDate.toString(),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio(
                      value: CategoryType.income,
                      groupValue: _selectedCategoryType,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategoryType = CategoryType.income;
                          _categoryID = null;
                        });
                      },
                    ),
                    const Text("Income"),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: CategoryType.exoense,
                      groupValue: _selectedCategoryType,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategoryType = CategoryType.exoense;
                          _categoryID = null;
                        });
                      },
                    ),
                    const Text("Expense"),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            DropdownButton<String>(
                hint: const Text("Select Category"),
                value: _categoryID,
                items: (_selectedCategoryType == CategoryType.income
                        ? CategoryDB().IncomeCategoryListListner
                        : CategoryDB().ExpenseCategoryListListner)
                    .value
                    .map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                    onTap: (){
                      _selectedCategoryModel = e;
                    },
                  );
                }).toList(),
                onChanged: (selectedValue) {
                  print(selectedValue);
                  setState(() {
                    _categoryID = selectedValue;
                  });
                }),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
            //  style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 29, 31, 43)),
              onPressed: () {
                addTransaction();
                
              },
              child: const Text("Submit"),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeTextEditingController.text;
    final _amonutText = _amountTextEditingController.text;
    if (_purposeText.isEmpty) {
      return;
    }
    if (_amonutText.isEmpty) {
      return;
    }
    // _selectedDate
    // _selecteCategoryType
    if (_categoryID == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    if(_selectedCategoryModel == null){
      return;
    }

    final _parsedAmount = double.tryParse(_amonutText);

    if(_parsedAmount == null){
      return ;
    }
   final _model = TransactionModel(
      purpose: _purposeText,
      amount: _parsedAmount,
      category: _selectedCategoryModel!,
      date: _selectedDate!,
      type: _selectedCategoryType!,
    );
   await TransactionDB.instance.addTransaction(_model);
   Navigator.of(context).pop();
   TransactionDB.instance.refresh();
  }
}
