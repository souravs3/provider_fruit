import 'package:flutter/material.dart';
import 'package:fruit_provider/models/cart_model.dart';
import 'package:fruit_provider/service/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  //initialize Database helper

  DbHelper _db = DbHelper();
  //counter
  int _counter = 0;
  int get counter => _counter;

  //total price

  double _totalprice = 0.0;
  double get totalPrice => _totalprice;

  //cart list

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart;

  Future<List<Cart>> getData() async {
    _cart = _db.getCardList();
    return _cart;
  }

  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalprice);
    notifyListeners();
  }

  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalprice = prefs.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }

  void addCounter() {
    _counter++;
    _setPrefItems();
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    _setPrefItems();
    notifyListeners();
  }

  int getCounter() {
    _getPrefItems();
    return _counter;
  }

  //price

  void addTotalPrice(double productPrice) {
    _totalprice = _totalprice + productPrice;
    _setPrefItems();
    notifyListeners();
  }

  void removeTotalPrice(double productPrice) {
    _totalprice = _totalprice - productPrice;
    _setPrefItems();
    notifyListeners();
  }

  double getTotalPrice() {
    _getPrefItems();
    return _totalprice;
  }
}
