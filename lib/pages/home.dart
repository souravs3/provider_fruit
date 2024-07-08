import 'package:flutter/material.dart';
import 'package:fruit_provider/controller/cart_provider.dart';
import 'package:fruit_provider/models/cart_model.dart';
import 'package:fruit_provider/models/fruitlist.dart';
import 'package:fruit_provider/pages/cart_screen.dart';
import 'package:fruit_provider/service/db_helper.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({super.key});

  Fruitlists fruitlists = Fruitlists();

  DbHelper? dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Colors.pink,
      appBar: AppBar(
        title: Text(
          'Product List',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 28),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Badge(
                alignment: Alignment.topRight,
                label: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(
                      value.getCounter().toString(),
                      style: TextStyle(color: Colors.black),
                    );
                  },
                ),
                backgroundColor: Colors.white,
                textColor: Colors.white,
                child: Icon(Icons.shopping_bag_outlined)),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: fruitlists.productImage.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Card(
                        color: Colors.pink.shade100,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 30, horizontal: 10),
                                      child: Image.asset(
                                          width: 80,
                                          height: 80,
                                          fruitlists.productImage[index]),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          fruitlists.productName[index],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              letterSpacing: 2),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              fruitlists.productUnit[index],
                                              style: TextStyle(
                                                  color: Colors.grey.shade800,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 2,
                                                  fontSize: 12),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                                '\$' +
                                                    fruitlists
                                                        .productPrice[index]
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Colors.grey.shade900,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 2,
                                                    fontSize: 14))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    dbHelper!
                                        .insert(Cart(
                                            id: index,
                                            productId: index.toString(),
                                            productName:
                                                fruitlists.productName[index],
                                            initialPrice:
                                                fruitlists.productPrice[index],
                                            productPrice:
                                                fruitlists.productPrice[index],
                                            quantity: 1,
                                            unitTag:
                                                fruitlists.productUnit[index],
                                            image:
                                                fruitlists.productImage[index]))
                                        .then((onValue) {
                                      print('Product is added successfully');
                                      cart.addTotalPrice(double.parse(fruitlists
                                          .productPrice[index]
                                          .toString()));
                                      cart.addCounter();
                                    }).onError((handleError, StackTrace) {
                                      print(handleError.toString());
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CartScreen()));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10, top: 80),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.pink,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      'Add to Cart',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
