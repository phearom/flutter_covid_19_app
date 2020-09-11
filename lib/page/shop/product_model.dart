import 'package:flutter/material.dart';

class ProductModel {
  String id;
  String name;
  Color color;
  ProductModel({this.id, this.name, this.color});
}

var products = [
  ProductModel(id: "001", name: "CocaCola for you", color: Colors.red),
  ProductModel(id: "002", name: "Pepsi Henerdes", color: Colors.green),
  ProductModel(id: "003", name: "Anchor", color: Colors.blue),
  ProductModel(id: "004", name: "Tiger", color: _hexColor('900000')),
  ProductModel(id: "005", name: "ABC soft drink", color: Colors.blueAccent),
  ProductModel(id: "006", name: "Singha", color: _hexColor('7F5D20')),
  ProductModel(id: "007", name: "Angkor", color: Colors.yellow),
  ProductModel(id: "008", name: "Ichitan", color: Colors.amberAccent),
  ProductModel(id: "009", name: "Oishi", color: Colors.blueGrey),
  ProductModel(id: "010", name: "Oishi", color: _hexColor('8950BD')),
  ProductModel(id: "011", name: "Oishi", color: Colors.blueGrey),
  ProductModel(id: "012", name: "Oishi", color: _hexColor('F1A522')),
  ProductModel(id: "013", name: "Singha", color: Colors.green),
  ProductModel(id: "014", name: "Angkor", color: Colors.yellow),
  ProductModel(id: "015", name: "Ichitan", color: Colors.amberAccent),
];

Color _hexColor(String color) {
  color = color.replaceAll("#", "");
  if (color.length == 6) {
    return Color(int.parse("0xFF" + color));
  } else if (color.length == 8) {
    return Color(int.parse("0x" + color));
  }
  return Colors.white; //if no color match
}
