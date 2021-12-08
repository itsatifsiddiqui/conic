import 'package:conic/providers/app_user_provider.dart';
import 'package:flutter/material.dart';

import 'package:conic/models/card_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../res/res.dart';

class ViewCardScreen extends StatelessWidget {
  final CardModel cardModel;
  const ViewCardScreen({
    Key? key,
    required this.cardModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer(
      builder: (context, watch, child) {
        final user = watch(appUserProvider);
        return Scaffold(
          appBar: AppBar(
            title: cardModel.name!.text.semiBold.color(context.adaptive).make(),
            centerTitle: true,
            actions: [
              Center(
                child: 'Edit'.text.size(16).semiBold.color(AppColors.primaryColor).make(),
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
                    ),
                    Center(
                      child: Image.network(
                        cardModel.photo!,
                        height: size.height * 0.2,
                        width: size.width * 0.34,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const DisplayInformationWidget(
                      subTitle: 'Personal Card',
                      title: 'Title',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const DisplayInformationWidget(
                      subTitle: 'This is my personel card',
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
                          if (cardModel.accounts!.contains(e.fullLink))
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
