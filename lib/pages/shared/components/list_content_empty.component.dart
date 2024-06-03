import 'package:flutter/material.dart';

class ListContentEmpty extends StatelessWidget {
  const ListContentEmpty({super.key, this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 56.0),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 56.0),
            const SizedBox(height: 16.0),
            Text(
              errorMessage ?? 'Nada por aqui!',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
    // throw UnimplementedError();
  }
}
