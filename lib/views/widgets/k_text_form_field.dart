import 'package:flutter/material.dart';

class KTextFormField extends StatelessWidget {
  const KTextFormField({
    super.key,
    required TextEditingController controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1
  }) : _titleController = controller;

  final TextEditingController _titleController;
  final String label;
  final TextInputType keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _titleController,
      decoration:  InputDecoration(labelText: label),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
