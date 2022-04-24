import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/models/category/category_model.dart';

const CATEGORY_DB_NAME = "category_database";

abstract class CategoryDbFunctions {
  Future<void> insertCategory(CategoryModel value);
  Future<List<CategoryModel>> getCategories();
  Future<void>deleteCategory(String CategoryID);
}

class CategoryDB implements CategoryDbFunctions {


CategoryDB._internal();
static CategoryDB instance = CategoryDB._internal();
factory CategoryDB(){
  return instance;
}



  ValueNotifier<List<CategoryModel>> IncomeCategoryListListner = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> ExpenseCategoryListListner = ValueNotifier([]);
  @override
  Future<void> insertCategory(CategoryModel value) async {
    final _categoryDb = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    _categoryDb.put(value.id,value);
    refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _categoryDb = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _categoryDb.values.toList();
  }

  Future<void> refreshUI() async {
    final _allCategories = await getCategories();
    IncomeCategoryListListner.value.clear();
    ExpenseCategoryListListner.value.clear();
    Future.forEach(
      _allCategories,
      (CategoryModel category) {
        if (category.type == CategoryType.income) {
          IncomeCategoryListListner.value.add(category);
        } else {
          ExpenseCategoryListListner.value.add(category);
        }
      },
    );
    IncomeCategoryListListner.notifyListeners();
    ExpenseCategoryListListner.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String CategoryID) async {
 final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
 await _categoryDB.delete(CategoryID);
 refreshUI();
  }

  
}
