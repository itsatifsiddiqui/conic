import 'package:conic/widgets/info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/app_user_provider.dart';
import '../../../res/res.dart';
import 'follow_requests_screen.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Notifications'.text.semiBold.color(context.adaptive).make(),
        // actions: [
        //   IconButton(
        //     icon: const Icon(
        //       Icons.help_outline_rounded,
        //     ),
        //     onPressed: () {},
        //   )
        // ],
      ),
      body: Column(
        children: [
          Divider(height: 0, color: context.adaptive12),
          _FollowRequests(),
          Divider(height: 0, color: context.adaptive12),
          const InfoWidget(
            text: 'Work in progress',
            subText: 'Notifications will be implemented in later module',
          ).expand(),
        ],
      ),
    );
  }
}

class _FollowRequests extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final followRequestsRecieved =
        useProvider(appUserProvider.select((value) => value!.followRequestsRecieved ?? []));
    debugPrint(followRequestsRecieved.toString());
    final requestsLength = followRequestsRecieved.length;
    return ListTile(
      onTap: () {
        Get.to<void>(() => const FollowRequestsScreen());
      },
      title: 'Folow Requests'.text.semiBold.make(),
      trailing: requestsLength == 0
          ? const SizedBox()
          : Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.primaryColor,
              ),
              child: '$requestsLength'.text.bold.color(Colors.white).make(),
            ),
    );
  }
}
