import 'package:flutter/material.dart';
import 'package:shopping_helper/modules/item_list/models/item_list_item.model.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    super.key,
    required this.item,
    this.onTap,
    this.onLongTap,
  });

  final ItemListItem item;
  final void Function()? onTap;
  final void Function()? onLongTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key('list-tile-${item.id}'),
      leading: Checkbox(
        value: item.pickedUp,
        onChanged: (_) => onTap?.call(),
        visualDensity: VisualDensity.compact,
      ),
      trailing: item.calculatedPrice != null
          ? Text(
              'R\$ ${item.calculatedPrice?.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleSmall,
            )
          : null,
      title: Text(item.title),
      subtitle: Text(item.quantityWithUnit),
      onTap: onTap,
      onLongPress: onLongTap,
    );
  }
}
