import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:shopping_helper/core/extensions/string.extension.dart';
import 'package:shopping_helper/modules/item_list/models/item_list_item.model.dart';
import 'package:shopping_helper/modules/item_list/models/unit_type.model.dart';

class ItemEditView extends StatelessWidget {
  ItemEditView({
    super.key,
    required this.onSubmitted,
    required ItemListItem currentItem,
  })  : _itemStream = BehaviorSubject.seeded(currentItem),
        _nameController = TextEditingController(text: currentItem.title),
        _priceController = MoneyMaskedTextController(initialValue: currentItem.currentUnitPrice),
        _quantityController = TextEditingController(text: currentItem.quantityAsString),
        _observationsController = TextEditingController(text: currentItem.attentionPoints);

  final bool Function(ItemListItem) onSubmitted;
  final BehaviorSubject<ItemListItem> _itemStream;

  // TextEditingController
  final TextEditingController _nameController;
  final TextEditingController _priceController;
  final TextEditingController _quantityController;
  final TextEditingController _observationsController;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final viewInsets = MediaQuery.of(context).viewInsets;
    final optimalHeight = (screenSize.height - viewInsets.bottom) * 0.7;

    return StreamBuilder(
      stream: _itemStream,
      builder: (BuildContext context, AsyncSnapshot<ItemListItem> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final currentItem = snapshot.data!;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          constraints: BoxConstraints.tightFor(height: optimalHeight),
          child: SafeArea(
            child: ListView(
              children: [
                Text(
                  'Editar item',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    autocorrect: true,
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
                  child: TextFormField(
                    controller: _priceController,
                    autofocus: true,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
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
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
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
                            helperText:
                                'Exemplo: 200mL, 1L, 3 unidades, 1kg, ...',
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
                          _itemStream.add(currentItem.copyWith(unitType: type));
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
                        // onTap: () => setState(
                        // () => totalPriceEnabled = !totalPriceEnabled,
                        // ),
                        onTap: () {
                          _itemStream
                              .add(currentItem.copyWith(fixedPrice: true));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: currentItem.fixedPrice ?? false,
                              onChanged: (value) => _itemStream.add(
                                currentItem.copyWith(fixedPrice: value),
                              ),
                            ),
                            const Text('Preço total'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
              ],
            ),
          ),
        );
      },
    );
  }

  bool onSubmit(ItemListItem currentItem) {
    final updatedItemWithControllers = currentItem.copyWith(
      title: _nameController.text,
      quantity: double.parse(_quantityController.text),
      attentionPoints: _observationsController.text,
      currentUnitPrice: _priceController.text.fromMoneyToDouble(),
    );
    return onSubmitted(updatedItemWithControllers);
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
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          OutlinedButton(
            onPressed: onCancelPressed,
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: onSavePressed,
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
