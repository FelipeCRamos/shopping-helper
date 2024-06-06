import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_helper/modules/shopping_list/shopping_list.cubit.dart';
import 'package:shopping_helper/modules/shopping_list/shopping_list.state.dart';
import 'package:shopping_helper/pages/shared/components/list_content_empty.component.dart';
import 'package:shopping_helper/pages/shared/components/list_content_loading.component.dart';

import 'add/add_list.view.dart';
import 'shopping_list.content.dart';

class ShoppingListView extends StatelessWidget {
  const ShoppingListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        final bloc = context.read<ShoppingListCubit>();
        Widget body;

        if (state.isLoading) {
          body = const ListContentLoading();
        } else if (state.items?.isNotEmpty ?? false) {
          body = ShoppingListContent(state: state);
        } else {
          body = const ListContentEmpty(
            errorMessage: 'Nenhuma lista criada até o momento.',
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Listas de compras',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            actions: [
              IconButton(
                icon: Icon(state.isEditing ? Icons.edit_off : Icons.edit),
                onPressed: bloc.toggleEditMode,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: bloc.loadItems,
              )
            ],
          ),
          floatingActionButton: Builder(
            builder: (BuildContext ctx) {
              return FloatingActionButton.extended(
                label: const Text('Nova lista'),
                icon: const Icon(Icons.add),
                onPressed: () {
                  debugPrint('Performing add list navigation');
                  showModalBottomSheet(
                    context: ctx,
                    builder: (BuildContext context) => AddListView(
                      onSubmit: ctx.read<ShoppingListCubit>().addList,
                    ),
                  );
                },
              );
            },
          ),
          body: body,
        );
      },
    );
  }
}
