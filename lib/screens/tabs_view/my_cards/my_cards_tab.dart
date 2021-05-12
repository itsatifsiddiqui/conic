import 'package:flutter/material.dart';

import '../../../res/res.dart';

class MyCardsTab extends StatelessWidget {
  const MyCardsTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'My Cards'.text.semiBold.color(context.adaptive).make(),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.help_outline_rounded,
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
