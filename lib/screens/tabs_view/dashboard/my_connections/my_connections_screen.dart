import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../providers/app_user_provider.dart';
import '../../../../res/res.dart';
import 'followers_tab.dart';
import 'following_tab.dart';

class MyConnectionScreen extends StatelessWidget {
  const MyConnectionScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _UsernameAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          12.heightBox,
          'My Connections'.text.lg.semiBold.make().px16(),
          12.heightBox,
          HookBuilder(
            builder: (context) {
              final index = useState(0);
              final tabController = useTabController(initialLength: 2);
              return Column(
                children: [
                  TabBar(
                    controller: tabController,
                    onTap: (value) {
                      index.value = value;
                    },
                    tabs: [
                      Tab(
                        child: 'Followers'.text.make(),
                      ),
                      Tab(
                        child: 'Following'.text.make(),
                      ),
                    ],
                  ),
                  Expanded(
                    child: const [
                      FollowersTab(),
                      FollowingTab(),
                    ].elementAt(index.value),
                  ),
                ],
              ).expand();
            },
          )
        ],
      ),
    );
  }
}

class _UsernameAppBar extends HookWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final userName =
        useProvider(appUserProvider.select((value) => value!.username)) ?? 'My Connections';

    return AppBar(
      centerTitle: true,
      title: '@$userName'.text.xl.color(context.adaptive).make(),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
