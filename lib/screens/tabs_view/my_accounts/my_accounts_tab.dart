import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/linked_account.dart';
import '../../../providers/app_user_provider.dart';
import '../../../res/res.dart';

final businessModeProvider = StateProvider<bool>((ref) => false);
final isListModeProvider = StateProvider<bool>((ref) => false);
final queryProvider = StateProvider<String>((ref) => '');

///Listen to [queryProvider] and return filtered results
final filteredAccountsStateProvider = StateProvider<List<LinkedAccount>>((ref) {
  final query = ref.watch(queryProvider).state.trim().toLowerCase();
  final allAccounts = ref.watch(appUserProvider)!.linkedAccounts ?? [];
  if (query.isEmpty) return allAccounts;
  return allAccounts.where((element) => element.title.toLowerCase().contains(query)).toList();
});

class MyAccountsTab extends StatelessWidget {
  const MyAccountsTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: 'My Accounts'.text.semiBold.color(context.adaptive).make(),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Greetings(),
          12.heightBox,
          CupertinoSearchTextField(
            borderRadius: BorderRadius.circular(kBorderRadius),
            placeholder: 'Search account',
            prefixInsets: const EdgeInsets.all(8),
            style: TextStyle(color: context.adaptive),
            onChanged: (value) {
              context.read(queryProvider).state = value;
            },
          ),
          20.heightBox,
          const _MyAccountsTextRow(),
          24.heightBox,
          _MyAccountsBuilder(),
        ],
      ).px16().scrollVertical(),
    );
  }
}

class _MyAccountsTextRow extends StatelessWidget {
  const _MyAccountsTextRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(child: 'My Accounts'.text.xl2.semiBold.tight.make()),
            'Long press for more options.'.text.sm.color(context.adaptive75).make(),
          ],
        ).expand(),
        HookBuilder(
          builder: (context) {
            final isListMode = useProvider(isListModeProvider).state;
            return IconButton(
              icon: Icon(
                isListMode ? Icons.grid_view : Icons.list_alt_sharp,
                color: context.primaryColor,
              ),
              onPressed: () {
                context.read(isListModeProvider).state = !context.read(isListModeProvider).state;
              },
            );
          },
        )
      ],
    );
  }
}

class _Greetings extends HookWidget {
  const _Greetings({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final name = useProvider(appUserProvider.select((value) => value?.name ?? 'Conic user'));
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(child: 'Hi, $name'.text.xl3.extraBold.tight.make()),
            4.heightBox,
            'View My Profile'.text.base.color(context.adaptive75).make(),
          ],
        ).expand(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            HookBuilder(
              builder: (context) {
                final isBusinesssMode = useProvider(businessModeProvider).state;
                return CupertinoSwitch(
                  activeColor: context.primaryColor,
                  value: isBusinesssMode,
                  onChanged: (value) {
                    context.read(businessModeProvider).state = value;
                  },
                );
              },
            ),
            4.heightBox,
            'Switch to business'.text.xs.color(context.adaptive87).make(),
          ],
        )
      ],
    ).py8();
  }
}

class _MyAccountsBuilder extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isListMode = useProvider(isListModeProvider).state;
    final accounts = useProvider(filteredAccountsStateProvider).state;

    if (isListMode) {
      return ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: accounts.map((e) {
          return GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.adaptive.withOpacity(0.04),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  4.widthBox,
                  Hero(
                    tag: e.image,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: e.image,
                        width: 36,
                        height: 36,
                      ),
                    ),
                  ),
                  12.widthBox,
                  e.title.text.lg.medium.color(context.adaptive87).make().expand()
                ],
              ),
            ),
          );
        }).toList(),
      );
    }
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 4,
      mainAxisSpacing: 16,
      crossAxisSpacing: 8,
      children: accounts.map((e) {
        return GestureDetector(
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(imageUrl: e.image),
          ),
        );
      }).toList(),
    );
  }
}
