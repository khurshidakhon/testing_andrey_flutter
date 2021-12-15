// ignore: file_names

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

class ActionsWidget extends StatefulWidget {
  @override
  _ActionsWidgetState createState() => _ActionsWidgetState();
}

class _ActionsWidgetState extends State<ActionsWidget> with ChangeNotifier {
  List<Sale> sale = [];
  List<Sale> get sales {
    return [...sale];
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://bonus.andreyp.ru/api/v1/promos?page=&count=10';
    final response = await http.get(Uri.parse(url));
    final List<Sale> loadedSales = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((id, sale) {
      loadedSales.add(
        Sale(
          id: sale['id'],
          shop: sale['shop'],
          shop_id: sale['shop_id'],
          name: sale['name'],
          description: sale['description'],
          img_thumb: sale['img_thumb'],
          img_full: sale['img_full'],
          shop_description: sale['shop_description'],
        ),
      );
    });
    sale = loadedSales;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            "Акции",
          )),
        ),
        body: Container(
          child: StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            padding: const EdgeInsets.only(
              right: 15,
              left: 15,
            ),
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                color: index % 2 == 0 ? Colors.black : Colors.deepOrange,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      sale[index].img_thumb,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    sale[index].name,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
            staggeredTileBuilder: (i) {
              return StaggeredTile.count(1, i.isOdd ? 1 : 1.5);
            },
          ),
        ),
      ),
    );
  }
}

class Sale {
  final int id;
  final String shop;
  final int shop_id;
  final String name;
  final String description;
  final String img_thumb;
  final String img_full;
  final String shop_description;

  Sale({
    this.id,
    this.shop,
    this.shop_id,
    this.name,
    this.description,
    this.img_thumb,
    this.img_full,
    this.shop_description,
  });
}
