import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shopping_helper/modules/shopping_list/shopping_list.cubit.dart';

class ShoppingListItem extends StatelessWidget {
  final String id;
  final String title;
  final bool editMode;

  final void Function()? onTap;
  final void Function()? onLongTap;
  final void Function()? onRemoveTap;

  const ShoppingListItem({
    super.key,
    required this.id,
    required this.title,
    this.editMode = false,
    this.onTap,
    this.onLongTap,
    this.onRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: editMode
          ? IconButton(
              icon: const Icon(Icons.remove_circle),
              onPressed: onRemoveTap,
            )
          : null,
      title: Text(title),
      onTap: onTap,
      onLongPress: onLongTap,
    );
  }
}
