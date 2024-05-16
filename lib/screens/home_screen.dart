import 'package:flutter/material.dart';
import 'package:sqflite_example/db/sql_helper.dart';
import 'package:sqflite_example/screens/add_item_screen.dart';
import 'package:sqflite_example/screens/components/item_list.dart';
import 'package:sqflite_example/utils/util.dart';

import '../model/db_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List of DBItems
  List<DBItem> _journals = [];

  // For showing Loading Progress Bar
  bool _isLoading = true;

  // For refreshing the list on init, or after performing CRUD operations
  void _refreshJournals() async {
    final data = await SQLHelper.getAllItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  // Add Item to DB
  void addItem(DBItem dbItem) async {
    try {
      await SQLHelper.createItem(dbItem);
    } catch (err) {
      if (context.mounted) {
        Util.showCustomSnackBar(context, "Failed to insert item. Error: $err");
      }
    }
  }

  // Update Item to DB
  void updateItem(DBItem dbItem) async {
    try {
      final updateResult = await SQLHelper.updateItem(dbItem);
      if (context.mounted) {
        Util.showCustomSnackBar(
            context, "Update Successful. Result: $updateResult");
      }
    } catch (err) {
      if (context.mounted) {
        Util.showCustomSnackBar(context, "Failed to insert item. Error: $err");
      }
    }
  }

  void _showForm(int? id) async {
    String? title;
    String? description;

    if (id != null) {
      final existingJournal =
          _journals.firstWhere((element) => element.id == id);
      title = existingJournal.title;
      description = existingJournal.description;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      elevation: 5,
      builder: (_) {
        return AddItemScreen(
          itemId: id,
          titleText: (title != null) ? title : null,
          descriptionText: (description != null) ? description : null,
          onAddUpdatePressed: (String itemTitle, String itemDescription) {
            // Add or Update based on id value
            if (id != null) {
              final DBItem item = DBItem(id, itemTitle, itemDescription, null);
              updateItem(item);
            } else {
              final DBItem item =
                  DBItem(null, itemTitle, itemDescription, null);
              addItem(item);
            }

            // Refresh the list after the operation
            _refreshJournals();
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQFLite Example")),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: (!_isLoading)
            ? ItemList(
                journals: _journals,
                onItemTapped: (itemId) => _showForm(itemId),
                onItemLongPressed: (itemId) async {
                  await SQLHelper.deleteItem(itemId);
                  _refreshJournals();
                },
              )
            : const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
