import 'package:flutter/material.dart';

class AddListView extends StatelessWidget {
  const AddListView({super.key, this.onSubmit});

  final void Function(String)? onSubmit;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, viewInsets.bottom + 24),
      child: SafeArea(
        child: TextFormField(
          autofocus: true,
          keyboardType: TextInputType.text,
          autocorrect: false,
          maxLines: 1,
          onTapOutside: (_) {
            Navigator.of(context).pop();
          },
          decoration: const InputDecoration(
            labelText: 'Nome da nova lista',
            hintText: 'Compras do final de semana',
          ),
          onFieldSubmitted: (String listName) {
            onSubmit?.call(listName);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
