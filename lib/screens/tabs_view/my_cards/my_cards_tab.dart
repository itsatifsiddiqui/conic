import 'package:conic/widgets/info_widget.dart';
import 'package:flutter/material.dart';

import '../../../res/res.dart';

class MyCardsTab extends StatelessWidget {
  const MyCardsTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'My Cards'.text.semiBold.color(context.adaptive).make(),
        // actions: [
        //   IconButton(
        //     icon: const Icon(
        //       Icons.help_outline_rounded,
        //     ),
        //     onPressed: () {},
        //   )
        // ],
      ),
      body: const InfoWidget(
        text: 'Work in progress',
        subText: 'This module will be implemented later',
      ),
    );
  }
}
