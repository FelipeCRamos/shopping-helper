import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:shopping_helper/core/extensions/string.extension.dart';

class ItemAddPriceView extends StatefulWidget {
  const ItemAddPriceView({
    super.key,
    required this.onSubmitted,
  });

  final bool Function(double, bool) onSubmitted;

  @override
  State<StatefulWidget> createState() => ItemAddPriceViewState();
}

class ItemAddPriceViewState extends State<ItemAddPriceView> {
  bool checkboxTapped = false;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Adicionar preço ao item',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextFormField(
                controller: _controller,
                autofocus: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                autocorrect: false,
                maxLines: 1,
                decoration: const InputDecoration(
                  prefixText: 'R\$ ',
                  hintText: '0.00 [Preço por unidade]',
                ),
                onFieldSubmitted: (String price) {
                  if (onSubmit(price)) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () =>
                        setState(() => checkboxTapped = !checkboxTapped),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: checkboxTapped,
                          onChanged: (value) => setState(
                            () => checkboxTapped = value ?? false,
                          ),
                        ),
                        const Text('Preço total'),
                      ],
                    ),
                  ),
                  FilledButton(
                    child: const Text('Salvar'),
                    onPressed: () {
                      if (onSubmit(_controller.text)) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool onSubmit(String value) {
    debugPrint('Preço adicionado $value, absoluto? $checkboxTapped');
    return widget.onSubmitted(value.fromMoneyToDouble(), checkboxTapped);
  }
}
