import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/home/screen_home.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transactons/transaction_model.dart';
import 'package:money_manager/screens/add_transaction/screen_add_transaction.dart';

Future<void> main() async {

WidgetsFlutterBinding.ensureInitialized();
 await Hive.initFlutter();

 if(!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
   Hive.registerAdapter(CategoryTypeAdapter());
 }

 if(!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
   Hive.registerAdapter(CategoryModelAdapter());
 }

 if(!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
   Hive.registerAdapter(TransactionModelAdapter());
 }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Manager',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home:const ScreenHome(),
      routes: {
        ScreenAddTransaction.routName:(context) =>const ScreenAddTransaction(),
      },
    );
  }
}

