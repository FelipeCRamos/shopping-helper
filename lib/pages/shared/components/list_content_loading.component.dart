import 'package:flutter/material.dart';

class ListContentLoading extends StatelessWidget {
  const ListContentLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
