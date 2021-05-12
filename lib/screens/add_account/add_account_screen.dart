import 'package:flutter/material.dart';
import '../../res/res.dart';

class AddAccountScreen extends StatelessWidget {
  const AddAccountScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Add new account'.text.semiBold.color(context.adaptive).make(),
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
