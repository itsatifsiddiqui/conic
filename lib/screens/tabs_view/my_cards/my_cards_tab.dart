import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conic/models/card_model.dart';
import 'package:conic/providers/app_user_provider.dart';
import 'package:conic/screens/tabs_view/my_cards/view_card_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../res/res.dart';
import 'add_card_screen.dart';

final queryProvider = StateProvider<String>((ref) => '');
final selectedCard = StateProvider<CardModel?>((ref) => null);

class MyCardsTab extends HookWidget {
  const MyCardsTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer(
      builder: (context, watch, child) {
        final user = watch(appUserProvider);
        watch(selectedCard).state;
        watch(addAccountsList).state;
        watch(queryProvider);
        return Scaffold(
          appBar: AppBar(
            title: 'My Cards'.text.semiBold.color(context.adaptive).make(),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.add,
                ),
                onPressed: () {
                  context.read(addAccountsList).state = [];
                  Get.to<void>(() => const AddCardScreen());
                },
              ),
            ],
            centerTitle: true,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: CupertinoSearchTextField(
                  borderRadius: BorderRadius.circular(kBorderRadius),
                  placeholder: 'Search card',
                  prefixInsets: const EdgeInsets.all(8),
                  style: TextStyle(color: context.adaptive),
                  onChanged: (value) {
                    context.read(queryProvider).state = value;
                    // print(context.read(queryProvider).state);
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection('users').doc(user!.userId).collection('cards').snapshots(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data!.docs.length == 0) {
                          return Center(
                            child: 'No Cards Added'.text.bold.size(20).color(Theme.of(context).dividerColor).make(),
                          );
                        }
                        final card = CardModel.fromMap(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                        if (context.read(queryProvider).state.isNotEmpty) {
                          if (card.name!.toLowerCase().contains(context.read(queryProvider).state)) {
                            return Dismissible(
                              key: Key(card.docId!),
                              confirmDismiss: (direction) async {
                                print(true);
                                bool delete = false;
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: 'No'.text.color(AppColors.primaryColor).size(16).bold.make()),
                                        15.widthBox,
                                        TextButton(
                                            onPressed: () {
                                              delete = true;
                                              Get.back();
                                            },
                                            child: 'Yes'.text.color(AppColors.primaryColor).size(16).bold.make()),
                                      ],
                                      title: 'Delete Card'
                                          .text
                                          .color(Theme.of(context).dividerColor)
                                          .size(16)
                                          .semiBold
                                          .make(),
                                      content: 'Are you sure you want to delete this Card?'
                                          .text
                                          .color(Theme.of(context).dividerColor)
                                          .size(14)
                                          .make(),
                                    );
                                  },
                                );
                                if (delete)
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.userId)
                                      .collection('cards')
                                      .doc(card.docId!)
                                      .delete();
                                return delete;
                              },
                              child: CardDisplayWidget(
                                card: card,
                                size: size,
                              ),
                            );
                          } else
                            return Container();
                        } else {
                          return Dismissible(
                            key: Key(card.docId!),
                            confirmDismiss: (direction) async {
                              print(true);
                              bool delete = false;
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    child: AlertDialog(
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: 'No'.text.color(AppColors.primaryColor).size(16).bold.make()),
                                        15.widthBox,
                                        TextButton(
                                            onPressed: () {
                                              delete = true;
                                              Get.back();
                                            },
                                            child: 'Yes'.text.color(AppColors.primaryColor).size(16).bold.make()),
                                      ],
                                      title: 'Delete Card'
                                          .text
                                          .color(Theme.of(context).dividerColor)
                                          .size(16)
                                          .semiBold
                                          .make(),
                                      content: 'Are you sure you want to delete this Card?'
                                          .text
                                          .color(Theme.of(context).dividerColor)
                                          .size(14)
                                          .make(),
                                    ),
                                  );
                                },
                              );
                              if (delete)
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.userId)
                                    .collection('cards')
                                    .doc(card.docId!)
                                    .delete();
                              return delete;
                            },
                            child: CardDisplayWidget(
                              card: card,
                              size: size,
                            ),
                          );
                        }
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CardDisplayWidget extends StatelessWidget {
  const CardDisplayWidget({
    Key? key,
    required this.card,
    required this.size,
  }) : super(key: key);

  final CardModel card;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return GestureDetector(
          onTap: () async {
            context.read(selectedCard).state = card;
            context.read(addAccountsList).state = card.accounts ?? [];
            await Get.to<void>(
              () => ViewCardScreen(),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      card.photo!,
                      height: size.height * 0.13,
                      width: size.width * 0.22,
                      fit: BoxFit.fill,
                    ),
                  ),
                  20.widthBox,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      card.name!.text.size(22).semiBold.color(context.adaptive).make(),
                      '${card.accounts!.length} Linked Accounts'.text.size(14).color(AppColors.grey).make(),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
