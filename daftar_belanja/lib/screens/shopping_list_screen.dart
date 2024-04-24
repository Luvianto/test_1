import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/service/shopping_service.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  final ShoppingService _shoppingService = ShoppingService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Belanja'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          )
        ],
      ),
      body: Column(
        children: [
          //Child yang pertama
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(hintText: 'Masukkan nama barang'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: genderController,
                    decoration:
                        const InputDecoration(hintText: 'Masukkan gender'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: descriptionController,
                  decoration:
                      const InputDecoration(hintText: 'Masukkan deskripsi'),
                )),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _shoppingService.addShoppingItem(
                      nameController.text,
                      descriptionController.text,
                      genderController.text,
                      context,
                    );
                    nameController.clear();
                    descriptionController.clear();
                    genderController.clear();
                  },
                )
              ],
            ),
          ),
          //Children yang kedua
          Expanded(
              child: StreamBuilder<Map<String, Map<String, String>>>(
            stream: _shoppingService.getShoppingList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, Map<String, String>> items = snapshot.data!;
                // print(items);
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final key = items.keys.elementAt(index);
                    final item = items[key];
                    return ListTile(
                      title: Text(item!['name']!),
                      subtitle: Text(
                          "desc: ${item['description']!}\ngend: ${item['gender']!}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _shoppingService.removeShoppingItem(key);
                        },
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ))
        ],
      ),
    );
  }
}
