import 'package:flutter/material.dart';
import 'package:shopping_helper/modules/item_list/models/item_list_item.model.dart';
import 'package:shopping_helper/core/extensions/double.extension.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    super.key,
    required this.item,
    this.onTap,
    this.onLongTap,
    required this.onRemove,
  });

  final ItemListItem item;
  final void Function()? onTap;
  final void Function()? onLongTap;
  final void Function() onRemove;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      key: Key('list-tile-${item.id}'),
      leading: Checkbox(
        value: item.pickedUp,
        onChanged: (_) => onTap?.call(),
        visualDensity: VisualDensity.compact,
      ),
      trailing: _TrailingSection(
        key: Key('_TrailingSection-${item.id}'),
        calculatedPrice: item.calculatedPrice,
        onRemove: onRemove,
      ),
      title: Text(
        item.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(item.prettyQuantityWithUnit),
      onTap: onTap,
      onLongPress: onLongTap,
    );
  }
}

class _TrailingSection extends StatelessWidget {
  const _TrailingSection({
    super.key,
    this.calculatedPrice,
    required this.onRemove,
  });

  final double? calculatedPrice;
  final void Function() onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (calculatedPrice != null)
          Text(
            calculatedPrice?.toMoneyString() ?? '',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        PopupMenuButton<Function()>(
          icon: const Icon(Icons.more_vert),
          onSelected: (anonyFunction) => anonyFunction.call(),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              value: onRemove,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete),
                  SizedBox(width: 12),
                  Text('Excluir item'),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
