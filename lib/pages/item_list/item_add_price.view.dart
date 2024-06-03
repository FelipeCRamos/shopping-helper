import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: SafeArea(
        child: TextFormField(
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autocorrect: false,
          maxLines: 1,
          decoration: InputDecoration(
            prefixText: 'R\$ ',
            hintText: '0.00 [Preço por unidade]',
            suffixIcon: Checkbox(
                value: checkboxTapped,
                onChanged: (value) =>
                    setState(() => checkboxTapped = value ?? false),),
            suffixText: 'p. absoluto',
          ),
          onTapOutside: (_) => Navigator.of(context).pop(),
          onFieldSubmitted: (String price) {
            debugPrint('Preço adicionado $price, absoluto? $checkboxTapped');
            if (widget.onSubmitted(double.parse(price), checkboxTapped)) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }
}
