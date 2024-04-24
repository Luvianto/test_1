import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ShoppingService {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('shopping-list');

  Stream<Map<String, Map<String, String>>> getShoppingList() {
    return _database.onValue.map((event) {
      final Map<String, Map<String, String>> items = {};
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          items[key] = {
            'name': value['Name'] as String,
            'description': value['No'] as String,
            'gender': value['Quantity'] as String,
          };
        });
      }
      return items;
    });
  }

  void addShoppingItem(String itemName, String description, String gender,
      BuildContext context) {
    if (itemName.isEmpty) {
      const warning = SnackBar(content: Text('Item Belanja Kosong!'));
      ScaffoldMessenger.of(context).showSnackBar(warning);
    } else {
      _database.push().set({
        'name': itemName,
        'description': description,
        'gender': gender,
      });
    }
  }

  Future<void> removeShoppingItem(String key) async {
    await _database.child(key).remove();
  }
}
