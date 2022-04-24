import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/models/category/category_model.dart';
 part 'transaction_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel {

  @HiveField(0)
  final String purpose;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  CategoryType type;

  @HiveField(4)
  final CategoryModel category;

  @HiveField(5)
   String? id;


  TransactionModel({
    required this.purpose,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
  })

  {
    id = DateTime.now().millisecondsSinceEpoch.toString();
  }

}
