import 'package:conic/providers/app_user_provider.dart';
import 'package:conic/screens/tabs_view/my_cards/edit_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../res/res.dart';
import 'my_cards_tab.dart';

class ViewCardScreen extends StatelessWidget {
  const ViewCardScreen({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer(
      builder: (context, watch, child) {
        final user = watch(appUserProvider);
        final card = watch(selectedCard).state;
        return Scaffold(
          appBar: AppBar(
            title: card!.name!.text.semiBold.color(context.adaptive).make(),
            centerTitle: true,
            actions: [
              Center(
                child: GestureDetector(
                    onTap: () {
                      Get.to<void>(() => EditCardScreen(
                            cardModel: card,
                          ));
                    },
                    child: 'Edit'.text.size(16).semiBold.color(AppColors.primaryColor).make()),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
          body: SizedBox(
            height: size.height,
            width: size.width,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                      width: double.infinity,
                    ),
                    Center(
                      child: Container(
                        child: Image.network(
                          card.photo!,
                          height: size.height * 0.2,
                          width: size.width * 0.34,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: double.infinity,
                      height: 20,
                    ),
                    DisplayInformationWidget(
                      subTitle: card.name ?? '',
                      title: 'Title',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DisplayInformationWidget(
                      subTitle: card.description ?? '',
                      title: 'Description',
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    'Linked Accounts'.text.size(22).semiBold.color(context.adaptive).make(),
                    const SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      spacing: 6,
                      runSpacing: 10,
                      children: user!.linkedAccounts!.map(
                        (e) {
                          if (card.accounts!.contains(e.fullLink))
                            return Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(e.image),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          else
                            return Container(width: 0, height: 0);
                        },
                      ).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DisplayInformationWidget extends StatelessWidget {
  const DisplayInformationWidget({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);
  final String title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          title.text.size(22).semiBold.color(context.adaptive).make(),
          subTitle.text.size(14).color(Theme.of(context).dividerColor).make(),
        ],
      ),
    );
  }
}
