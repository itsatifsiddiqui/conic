import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/account_model.dart';
import '../../providers/firestore_provider.dart';
import '../../res/res.dart';
import '../../widgets/adaptive_progress_indicator.dart';
import '../../widgets/custom_widgets.dart';

//HOLD THE STATE FOR ALL ACCOUNTS
final allAccountsStateProvider = StateProvider((ref) => <AccountModel>[]);

//FETCH THE ALL ACCOUNTS AND STORE IN ALL STATE PROVIDER
final allAccountsProvider = StreamProvider<List<AccountModel>>((ref) {
  return ref.read(firestoreProvider).getAllAccounts();
});

//Provider to hold the textfield result.
final queryProvider = StateProvider<String>((ref) => '');

///Listen to [queryProvider] and return filtered results
final filteredAccountsStateProvider = StateProvider<List<AccountModel>>((ref) {
  final query = ref.watch(queryProvider).state.trim().toLowerCase();
  final allAccounts = ref.watch(allAccountsStateProvider).state;
  if (query.isEmpty) return allAccounts;
  return allAccounts.where((element) => element.name.toLowerCase().contains(query)).toList();
});

//TOGGLE BETWEEN LIST AND GRID VIEW
final isListModeProvider = StateProvider<bool>((ref) => false);

class AddAccountScreen extends HookWidget {
  const AddAccountScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Add new account'.text.semiBold.color(context.adaptive).make(),
        actions: [
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
      ),
      body: useProvider(allAccountsProvider).when(
        data: (accounts) {
          scheduleMicrotask(() => context.read(allAccountsStateProvider).state = accounts);
          return Column(
            children: [
              12.heightBox,
              CupertinoSearchTextField(
                borderRadius: BorderRadius.circular(kBorderRadius),
                placeholder: 'Search account',
                prefixInsets: const EdgeInsets.all(8),
                style: TextStyle(color: context.adaptive),
                onChanged: (value) {
                  context.read(queryProvider).state = value;
                },
              ).px16(),
              12.heightBox,
              const _AccountsBuilder().expand(),
            ],
          );
        },
        loading: () => const AdaptiveProgressIndicator(),
        error: (e, s) => StreamErrorWidget(
          error: e.toString(),
          onTryAgain: () {
            context.refresh(allAccountsProvider);
          },
        ),
      ),
    );
  }
}

class _AccountsBuilder extends HookWidget {
  const _AccountsBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isListMode = useProvider(isListModeProvider).state;

    final allAccounts = useProvider(filteredAccountsStateProvider).state;

    if (isListMode) {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: allAccounts.map((e) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.adaptive.withOpacity(0.04),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                4.widthBox,
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: e.image,
                    width: 36,
                    height: 36,
                  ),
                ),
                12.widthBox,
                e.name.text.lg.medium.color(context.adaptive87).make().expand()
              ],
            ),
          );
        }).toList(),
      );
    }

    return GridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      crossAxisCount: 4,
      mainAxisSpacing: 16,
      crossAxisSpacing: 8,
      children: allAccounts.map((e) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(imageUrl: e.image),
        );
      }).toList(),
    );
  }
}
