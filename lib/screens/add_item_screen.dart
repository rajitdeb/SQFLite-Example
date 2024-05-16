import 'package:flutter/material.dart';

import '../utils/widget_contants.dart';

class AddItemScreen extends StatefulWidget {
  final int? itemId;
  final String? titleText;
  final String? descriptionText;
  final Function onAddUpdatePressed;

  const AddItemScreen({
    super.key,
    this.itemId,
    this.titleText,
    this.descriptionText,
    required this.onAddUpdatePressed,
  });

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    if (widget.itemId != null) {
      _titleController.text = widget.titleText!;
      _descriptionController.text = widget.descriptionText!;
    }
  }

  void clearTextFieldsAndCloseBottomSheet() {
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Screen Title Text
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0, top: 10.0),
            child: Text(
              "Add Item",
              style: kAddItemScreenTitleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          TextField(
            controller: _titleController,
            decoration: kAddItemScreenTextFieldInputDecoration.copyWith(
              hintText: "Enter Title",
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _descriptionController,
            decoration: kAddItemScreenTextFieldInputDecoration.copyWith(
              hintText: "Enter Description (Optional)",
            ),
          ),
          const SizedBox(height: 24.0),

          /// Add or Update Button
          MaterialButton(
            onPressed: () => addOrUpdateButtonPressed(),
            height: 50.0,
            color: Colors.blue,
            child: Text(
              (widget.itemId != null) ? "UPDATE" : "ADD ITEM",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16.0),

          /// Cancel Button
          MaterialButton(
            onPressed: () => clearTextFieldsAndCloseBottomSheet(),
            height: 50.0,
            color: Colors.red,
            child: const Text(
              "CANCEL",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    clearTextFieldsAndCloseBottomSheet();
    super.dispose();
  }

  void addOrUpdateButtonPressed() {
    final itemTitle = _titleController.value.text.trim();
    final itemDescription = _descriptionController.value.text.trim();

    if (itemTitle.isNotEmpty) {
      widget.onAddUpdatePressed(itemTitle, itemDescription);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter title to continue")),
      );
    }

    // Clearing the text fields text of bottom sheet
    // and closing bottom sheet
    clearTextFieldsAndCloseBottomSheet();
  }
}
