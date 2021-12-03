import 'package:conic/screens/tabs_view/my_cards/view_card_screen.dart';
import 'package:flutter/material.dart';
import '../../../res/res.dart';
import 'add_card_screen.dart';

class MyCardsTab extends StatelessWidget {
  const MyCardsTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: 'My Cards'.text.semiBold.color(context.adaptive).make(),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () {
              Get.to<void>(() => const AddCardScreen());
            },
          ),
        ],
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.to<void>(() => ViewCardScreen(
                    title: 'Personal Card',
                    imageUrl: index == 0
                        ? Images.google
                        : index == 1
                            ? Images.apple
                            : Images.facebook,
                  ));
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        index == 0
                            ? Images.google
                            : index == 1
                                ? Images.apple
                                : Images.facebook,
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
                        'Personal Card'.text.size(22).semiBold.color(context.adaptive).make(),
                        '$index Linked Accounts'.text.size(14).color(AppColors.grey).make(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: 3,
      ),
    );
  }
}
