import 'package:go_router/go_router.dart';
import 'package:shopping_helper/modules/in_device_sync/localdb.repository.dart';
import 'package:shopping_helper/pages/item_list/item_list.page.dart';
import 'package:shopping_helper/pages/shopping_list/shopping_list.page.dart';

GoRouter mainRouter(LocalDatabaseRepository repository) => GoRouter(
      initialLocation: '/shoppingLists',
      routes: [
        GoRoute(
          path: '/shoppingLists',
          builder: (context, state) => const ShoppingListPage(),
          routes: [
            GoRoute(
              path: ':listId',
              builder: (context, state) {
                final title = GoRouterState.of(context).extra as String?;
                final listId = state.pathParameters['listId'];

                if (title != null && listId != null) {
                  return ItemListPage(
                    title: title,
                    listId: listId,
                  );
                } else {
                  throw Exception(
                      'Title or listId null during route construction.');
                }
              },
            ),
          ],
        ),
      ],
    );
