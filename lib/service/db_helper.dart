import 'package:fruit_provider/models/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DbHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDataBase();
    return _db!;
  }

  initDataBase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cart.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    db.execute('''CREATE TABLE cart (id INTEGER PRIMARY KEY , 
        productId VARCHAR UNIQUE,
        productName TEXT,
        initialPrice INTEGER, 
        productPrice INTEGER , 
        quantity INTEGER, 
        unitTag TEXT , 
        image TEXT )''');
  }

  Future<Cart> insert(Cart cart) async {
    var dbClient = await db;
    await dbClient!.insert('cart', cart.toMap());
    return cart;
  }

  Future<List<Cart>> getCardList() async {
    var dbClient = await db;

    final List<Map<String, Object?>> queryList = await dbClient!.query('cart');

    return queryList.map((toElement) => Cart.fromMap(toElement)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await db;

    return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  //update

  Future<int> update(Cart cart) async {
    var dbClient = await db;

    return await dbClient!
        .update('cart', cart.toMap(), where: 'id = ?', whereArgs: [cart.id]);
  }
}
