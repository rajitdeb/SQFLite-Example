import 'package:flutter/material.dart';

import '../../model/db_item.dart';

class ItemList extends StatelessWidget {
  final List<DBItem> journals;
  final Function onItemTapped;
  final Function onItemLongPressed;

  const ItemList({
    super.key,
    required this.journals,
    required this.onItemTapped,
    required this.onItemLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: journals.length,
      itemBuilder: (context, pos) {
        return Card(
          elevation: 4.0,
          color: Colors.blue,
          child: ListTile(
            title: Text(
              journals[pos].title,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: (journals[pos].description.toString().isNotEmpty)
                ? Text(
                    journals[pos].description,
                    style: const TextStyle(color: Colors.white),
                  )
                : null,
            onTap: () => onItemTapped(journals[pos].id),
            onLongPress: () => onItemLongPressed(journals[pos].id),
          ),
        );
      },
    );
  }
}
