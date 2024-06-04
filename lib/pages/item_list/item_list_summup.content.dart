import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemListSummupContent extends StatelessWidget {
  const ItemListSummupContent({
    super.key,
    this.shouldAppear = false,
    this.calculatedBagValue,
  });

  final bool shouldAppear;
  final double? calculatedBagValue;

  @override
  Widget build(BuildContext context) {
    if(!shouldAppear || calculatedBagValue == null || calculatedBagValue == 0) {
      return const SizedBox();
    }

    return BottomAppBar(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 8),
                Text(
                  'R\$ ${NumberFormat().format(calculatedBagValue!)}',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
