import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:shopping_helper/core/extensions/string.extension.dart';
import 'package:shopping_helper/modules/item_list/models/item_list_item.model.dart';
import 'package:shopping_helper/modules/item_list/models/unit_type.model.dart';

class ItemEditView extends StatefulWidget {
  const ItemEditView({
    super.key,
    required this.onSubmitted,
    required this.currentItem,
    this.isAdding = false,
  });

  final bool Function(ItemListItem) onSubmitted;
  final ItemListItem currentItem;
  final bool isAdding;

  @override
  State<StatefulWidget> createState() => ItemEditViewState();
}

class ItemEditViewState extends State<ItemEditView> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late TextEditingController _observationsController;

  ItemListItem? nextItem;

  @override
  void initState() {
    _nameController = TextEditingController(
      text: widget.currentItem.title,
    );
    _priceController = MoneyMaskedTextController(
      initialValue: widget.currentItem.currentUnitPrice,
    );
    _quantityController = TextEditingController(
      text: widget.currentItem.quantityAsString,
    );
    _observationsController = TextEditingController(
      text: widget.currentItem.attentionPoints,
    );
    nextItem = widget.currentItem;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _observationsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final viewInsets = MediaQuery.of(context).viewInsets;
    final optimalHeight = (screenSize.height - viewInsets.bottom) * 0.7;

    final currentItem = nextItem!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      constraints: BoxConstraints.tightFor(height: optimalHeight),
      child: SafeArea(
        child: ListView(
          children: [
            _CancelOrSaveButtonRow(
              onSavePressed: () {
                if (onSubmit(currentItem)) {
                  Navigator.of(context).pop();
                }
              },
              onCancelPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // Text(
            // widget.isAdding ? 'Adicionar item' : 'Editar item',
            // textAlign: TextAlign.center,
            // style: Theme.of(context)
            // .textTheme
            // .titleMedium
            // ?.copyWith(fontWeight: FontWeight.w600),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                autocorrect: true,
                autofocus: widget.isAdding,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  hintText: 'Nome do item',
                  helperText: 'Exemplo: Banana, Maçã, Guaraná Latinha, ...',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: TextFormField(
                        controller: _priceController,
                        autofocus: !widget.isAdding,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          labelText: 'Preço',
                          prefixText: 'R\$ ',
                          hintText: '0.00',
                          helperText: 'Preço por unidade do item',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        labelText: 'Quantidade',
                        hintText: 'Quantidade do item',
                        helperText: '200mL, 1L, 3 un., 1kg, ...',
                      ),
                    ),
                  ),
                  PopupMenuButton<UnitType>(
                    initialValue: currentItem.unitType,
                    itemBuilder: (BuildContext context) {
                      return UnitType.values
                          .map(
                            (unitType) => PopupMenuItem<UnitType>(
                              value: unitType,
                              child: Text(unitType.name),
                            ),
                          )
                          .toList();
                    },
                    onSelected: (UnitType type) {
                      setState(() {
                        nextItem = currentItem.copyWith(unitType: type);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(currentItem.unitType.name),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextFormField(
                controller: _observationsController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                autocorrect: true,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'Observações',
                  hintText: 'Qualquer observação sobre o item',
                  helperText:
                      'Ex: "pegar mais maduras" ou "preferência por sabor X"...',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        nextItem = currentItem.copyWith(fixedPrice: true);
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: currentItem.fixedPrice ?? false,
                          onChanged: (value) => setState(() {
                            nextItem = currentItem.copyWith(fixedPrice: value);
                          }),
                        ),
                        const Text('Preço total'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool onSubmit(ItemListItem currentItem) {
    final updatedItemWithControllers = currentItem.copyWith(
      title: _nameController.text,
      quantity: double.tryParse(_quantityController.text),
      attentionPoints: _observationsController.text,
      currentUnitPrice: _priceController.text != ''
          ? _priceController.text.fromMoneyToDouble()
          : null,
    );
    return widget.onSubmitted(updatedItemWithControllers);
  }
}

class _CancelOrSaveButtonRow extends StatelessWidget {
  final void Function() onSavePressed;
  final void Function() onCancelPressed;

  const _CancelOrSaveButtonRow({
    required this.onSavePressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: onCancelPressed,
          child: Text(
            'Cancelar',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        TextButton(
          onPressed: onSavePressed,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
