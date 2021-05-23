import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/app_user_provider.dart';
import '../../../res/res.dart';

final businessModeProvider = StateProvider<bool>((ref) => false);

class MyAccountsTab extends StatelessWidget {
  const MyAccountsTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: 'My Accounts'.text.semiBold.color(context.adaptive).make(),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Greetings(),
          12.heightBox,
          CupertinoSearchTextField(
            borderRadius: BorderRadius.circular(kBorderRadius),
            placeholder: 'Search account',
            prefixInsets: const EdgeInsets.all(8),
            style: TextStyle(color: context.adaptive),
          ),
          20.heightBox,
          FittedBox(child: 'My Accounts'.text.xl2.semiBold.tight.make()),
          'Long press for more options.'.text.sm.color(context.adaptive75).make(),
          24.heightBox,
        ],
      ).px16().scrollVertical(),
    );
  }
}

class _Greetings extends HookWidget {
  const _Greetings({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final name = useProvider(appUserProvider.select((value) => value?.name ?? 'Conic user'));
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(child: 'Hi, $name'.text.xl3.extraBold.tight.make()),
            4.heightBox,
            'View My Profile'.text.base.color(context.adaptive75).make(),
          ],
        ).expand(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            HookBuilder(
              builder: (context) {
                final isBusinesssMode = useProvider(businessModeProvider).state;
                return CupertinoSwitch(
                  activeColor: context.primaryColor,
                  value: isBusinesssMode,
                  onChanged: (value) {
                    context.read(businessModeProvider).state = value;
                  },
                );
              },
            ),
            4.heightBox,
            'Switch to business'.text.xs.color(context.adaptive87).make(),
          ],
        )
      ],
    ).py8();
  }
}
