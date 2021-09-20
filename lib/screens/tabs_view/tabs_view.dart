import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../providers/dynamic_link_provider.dart';
import '../../providers/firestore_provider.dart';
import '../../res/res.dart';
import '../add_account/add_new_account_screen.dart';
import 'dashboard/dashboard_tab.dart';
import 'dashboard/my_connections/firend_detail.dart';
import 'my_accounts/my_accounts_tab.dart';
import 'my_cards/my_cards_tab.dart';
import 'notifications/notifications_tab.dart';

final tabsIndexProvider = StateProvider<int>((ref) => 0);

class TabsView extends StatefulHookWidget {
  const TabsView({Key? key, this.showScannedUserProfile = false}) : super(key: key);
  final bool showScannedUserProfile;

  @override
  _TabsViewState createState() => _TabsViewState();
}

class _TabsViewState extends State<TabsView> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback(handleDynamicLink);

    super.initState();
  }

  Future handleDynamicLink(dynamic _) async {
    log('handleDynamicLink() ${widget.showScannedUserProfile}', name: 'TabsView');
    if (widget.showScannedUserProfile && (!context.read(authProvider).linkOpened)) {
      context.read(authProvider).linkOpened = true;
      final linkShareUserId = context.read(dynamicLinkProvider).linkShareUserId;
      log('linkShareUserId: $linkShareUserId', name: 'TabsView');
      if (linkShareUserId == null) return;

      final user = await context.read(firestoreProvider).getUserDataById(linkShareUserId);

      // ignore: unawaited_futures
      Get.to<void>(FriendDetailScreen(friend: user, fromFollowing: false));
      context.read(dynamicLinkProvider).linkStatus = LinkStatus.noLink;
    }
  }

  @override
  Widget build(BuildContext context) {
    final index = useProvider(tabsIndexProvider).state;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: index,
        children: const [
          MyAccountsTab(),
          MyCardsTab(),
          SizedBox(),
          NotificationsTab(),
          DashboardTab(),
        ],
      ),
      bottomNavigationBar: const _BottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: () {
          Get.to<void>(() => const AddNewAccountScreen());
          // Get.to<void>(() => const ActivateNfcScreen());
        },
        tooltip: 'Add Account',
        child: const Icon(Icons.add_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _BottomNavigationBar extends HookWidget {
  const _BottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final index = useProvider(tabsIndexProvider).state;

    return BottomNavigationBar(
      currentIndex: index,
      onTap: (value) {
        if (value != 2) {
          context.read(tabsIndexProvider).state = value;
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: context.primaryColor,
      unselectedItemColor: context.adaptive45,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.apps_outlined).pOnly(top: 8),
          tooltip: 'Accounts',
          label: '',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.dns_outlined).pOnly(top: 8),
          tooltip: 'Cards',
          label: '',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.masks, color: Colors.transparent).pOnly(top: 8),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.notifications_outlined).pOnly(top: 8),
          tooltip: 'Notifications',
          label: '',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.dashboard_outlined).pOnly(top: 8),
          tooltip: 'Settings',
          label: '',
        )
      ],
    );
  }
}
