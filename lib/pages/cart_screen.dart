import 'package:flutter/material.dart';
import 'package:fruit_provider/controller/cart_provider.dart';
import 'package:fruit_provider/models/cart_model.dart';
import 'package:fruit_provider/pages/widget/total_price.dart';
import 'package:fruit_provider/service/db_helper.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DbHelper dbHelper = DbHelper();
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart List',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 28),
        ),
        actions: [
          Badge(
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
          SizedBox(
            width: 20,
          )
        ],
      ),

      //body

      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: cart.getData(),
              builder: (context, AsyncSnapshot<List<Cart>> snapShot) {
                if (snapShot.hasData) {
                  if (snapShot.data!.isEmpty) {
                    return Center(
                        child: Lottie.asset(
                      width: 200,
                      height: 200,
                      'images/lottie.json',
                    ));
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapShot.data!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Card(
                              color: Colors.pink.shade100,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 10),
                                            child: Image.asset(
                                              snapShot.data![index].image
                                                  .toString(),
                                              width: 100,
                                              height: 100,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    snapShot.data![index]
                                                        .productName
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 18,
                                                        letterSpacing: 2),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      dbHelper.delete(snapShot
                                                          .data![index].id);
                                                      cart.removeCounter();
                                                      cart.removeTotalPrice(
                                                          double.parse(snapShot
                                                              .data![index]
                                                              .productPrice
                                                              .toString()));
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.pink,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text(
                                                    snapShot
                                                        .data![index].unitTag
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors
                                                            .grey.shade800,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 2,
                                                        fontSize: 12),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    '\$${snapShot.data![index].productPrice.toString()}',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .grey.shade900,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 2,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                            ],
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              right: 2, top: 80, left: 3),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.pink,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  int quantity = snapShot
                                                      .data![index].quantity!;
                                                  int intialPrice = snapShot
                                                      .data![index]
                                                      .initialPrice!;
                                                  quantity--;
                                                  int newPrice =
                                                      quantity * intialPrice;

                                                  if (quantity > 0) {
                                                    dbHelper
                                                        .update(Cart(
                                                            id: snapShot
                                                                .data![index]
                                                                .id,
                                                            productId: snapShot
                                                                .data![index]
                                                                .productId!
                                                                .toString(),
                                                            productName: snapShot
                                                                .data![index]
                                                                .productName!,
                                                            initialPrice: snapShot
                                                                .data![index]
                                                                .initialPrice!,
                                                            productPrice:
                                                                newPrice,
                                                            quantity: quantity,
                                                            unitTag: snapShot
                                                                .data![index]
                                                                .unitTag!,
                                                            image: snapShot
                                                                .data![index]
                                                                .image!))
                                                        .then((onValue) {
                                                      newPrice = 0;
                                                      quantity = 0;
                                                      cart.removeTotalPrice(
                                                          double.parse(snapShot
                                                              .data![index]
                                                              .initialPrice!
                                                              .toString()));
                                                    }).onError((handleError,
                                                            stackTrace) {
                                                      print(handleError);
                                                    });
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                snapShot.data![index].quantity
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  int quantity = snapShot
                                                      .data![index].quantity!;
                                                  int intialPrice = snapShot
                                                      .data![index]
                                                      .initialPrice!;
                                                  quantity++;
                                                  int newPrice =
                                                      quantity * intialPrice;

                                                  dbHelper
                                                      .update(Cart(
                                                          id: snapShot
                                                              .data![index].id,
                                                          productId: snapShot
                                                              .data![index]
                                                              .productId!
                                                              .toString(),
                                                          productName: snapShot
                                                              .data![index]
                                                              .productName!,
                                                          initialPrice: snapShot
                                                              .data![index]
                                                              .initialPrice!,
                                                          productPrice:
                                                              newPrice,
                                                          quantity: quantity,
                                                          unitTag: snapShot
                                                              .data![index]
                                                              .unitTag!,
                                                          image: snapShot
                                                              .data![index]
                                                              .image!))
                                                      .then((onValue) {
                                                    newPrice = 0;
                                                    quantity = 0;
                                                    cart.addTotalPrice(
                                                        double.parse(snapShot
                                                            .data![index]
                                                            .initialPrice!
                                                            .toString()));
                                                  }).onError((handleError,
                                                          stackTrace) {
                                                    print(handleError);
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                } else if (snapShot.hasError) {
                  return Center(
                    child: Text('Error: ${snapShot.error}'),
                  );
                } else {
                  return Center(
                    child: Text('You have no data'),
                  );
                }
              },
            ),
            Consumer<CartProvider>(builder: (context, value, child) {
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2) == '0.00'
                    ? false
                    : true,
                child: PriceTag(
                    title: 'Sub Total',
                    value: r'$' + value.getTotalPrice().toStringAsFixed(2)),
              );
            })
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
