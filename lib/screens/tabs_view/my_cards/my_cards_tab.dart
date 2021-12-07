import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conic/models/card_model.dart';
import 'package:conic/providers/app_user_provider.dart';
import 'package:conic/screens/tabs_view/my_cards/view_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../res/res.dart';
import 'add_card_screen.dart';

class MyCardsTab extends HookWidget {
  const MyCardsTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer(
      builder: (context, watch, child) {
        final user = watch(appUserProvider);
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
          body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(user!.userId).collection('cards').snapshots(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final card = CardModel.fromMap(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                    return GestureDetector(
                      onTap: () {
                        Get.to<void>(
                          () => ViewCardScreen(
                            title: card.name!,
                            imageUrl: [Images.google, Images.facebook, Images.apple].elementAt(index),
                          ),
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
                              const SizedBox(
                                width: 20,
                              ),
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
                  itemCount: snapshot.data!.docs.length,
                );
              }),
        );
      },
    );
  }
}
