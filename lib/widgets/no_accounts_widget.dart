import 'package:flutter/material.dart';

import '../res/res.dart';
import '../screens/add_account/add_new_account_screen.dart';
import 'primary_button.dart';

class NoAccountsWidget extends StatelessWidget {
  const NoAccountsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black12,
      elevation: 12,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 2 / 1,
                  child: Container(
                    color: context.adaptive12,
                    child: Icon(
                      Icons.contact_mail,
                      size: 70,
                      color: context.adaptive,
                    ),
                  ),
                ),
              )
            ],
          ),
          12.heightBox,
          'Get started by adding your first account'.text.xl.center.semiBold.makeCentered().px16(),
          'Tap on button below or add icon at the center to add an account to your profile.\n\nAccounts added to your profile can be shared instantly.'
              .text
              .center
              .color(context.adaptive70)
              .makeCentered()
              .p12(),
          PrimaryButton(
            text: 'Add an account',
            onTap: () {
              Get.to<void>(() => const AddNewAccountScreen());
            },
          ).p12(),
        ],
      ),
    );
  }
}
