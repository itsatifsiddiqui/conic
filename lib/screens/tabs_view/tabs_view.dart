import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../res/res.dart';
import '../nfc/activate_nfc_screen.dart';
import 'dashboard/dashboard_tab.dart';
import 'my_accounts/my_accounts_tab.dart';
import 'my_cards/my_cards_tab.dart';
import 'notifications/notifications_tab.dart';

final tabsIndexProvider = StateProvider<int>((ref) => 0);

class TabsView extends HookWidget {
  const TabsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final index = useProvider(tabsIndexProvider).state;
    return Scaffold(
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
          // Get.to<void>(() => const AddAccountScreen());
          Get.to<void>(() => const ActivateNfcScreen());
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
