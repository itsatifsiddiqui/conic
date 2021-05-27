import 'package:conic/models/app_user.dart';
import 'package:conic/providers/app_user_provider.dart';
import 'package:conic/providers/firestore_provider.dart';
import 'package:conic/providers/paginated_docs_provider.dart';
import 'package:conic/res/res.dart';
import 'package:conic/screens/tabs_view/dashboard/my_connections/user_list_item.dart';
import 'package:conic/widgets/paginated_docs_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final followersProvider = StreamProvider.autoDispose<List<AppUser>>((ref) {
  return ref.read(firestoreProvider).getFollowers();
});

class FollowersTab extends HookWidget {
  const FollowersTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userId = useProvider(appUserProvider.select((value) => value!.userId))!;
    return PaginatedDocsBuilder(
      options: PaginationOptions(
        path: 'users',
        whereQuery: Where(
          arrayContains: true,
          field: 'followedBy',
          condition: userId,
        ),
      ),
      builder: (context, docs) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index].data()! as Map<String, dynamic>;
            final user = AppUser.fromMap(doc);
            return UserListItem(
              onTap: () {},
              image: user.image,
              username: user.username ?? 'username',
              name: user.name ?? 'Name',
              trailing: OutlinedButton(
                onPressed: () {},
                child: 'Remove'.text.sm.color(context.primaryColor).make(),
              ),
            );
          },
        );
      },
    );
  }
}
