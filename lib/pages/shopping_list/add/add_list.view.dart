import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_helper/modules/shopping_list/shopping_list.cubit.dart';

class AddListView extends StatelessWidget {
  const AddListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: SafeArea(
        child: TextFormField(
          autofocus: true,
          keyboardType: TextInputType.text,
          autocorrect: false,
          maxLines: 1,
          onTapOutside: (_) {
            Navigator.of(context).pop();
          },
          onFieldSubmitted: (String listName) {
            debugPrint('Nome da nova lista a ser criada: $listName');
            context.read<ShoppingListCubit>().addList(listName).then(
              (_) {
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
    );
  }
}
