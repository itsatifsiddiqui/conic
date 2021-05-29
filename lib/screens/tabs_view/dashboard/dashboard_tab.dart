import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../res/res.dart';
import '../../nfc/activate_nfc_screen.dart';
import 'my_connections/my_connections_screen.dart';
import 'my_profile/my_profile_screen.dart';
import 'search/search_users_screen.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Dashboard'.text.semiBold.color(context.adaptive).make(),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.help_outline_rounded,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                _ItemCard(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Get.to<void>(() => const MyConnectionScreen());
                  },
                  icon: Icons.group_sharp,
                  title: 'Connections',
                  subtitle: 'Friends & Followers',
                  gradient: AppColors.blueGradient,
                ),
                _ItemCard(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Get.to<void>(() => const ActivateNfcScreen(showBackButton: true));
                  },
                  icon: Icons.nfc_outlined,
                  title: 'Activate Account',
                  subtitle: 'NFC Rewrite',
                  gradient: AppColors.orangeGradient,
                ),
              ],
            ),
            6.heightBox,
            Row(
              children: [
                _ItemCard(
                  onTap: HapticFeedback.lightImpact,
                  icon: Icons.map,
                  title: 'Find Nearby',
                  subtitle: 'Nearby Users',
                  gradient: AppColors.redGradient,
                ),
                _ItemCard(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Get.to<void>(() => const SearchUsersScreen());
                  },
                  icon: Icons.person_search_outlined,
                  title: 'Search',
                  subtitle: 'Find Users',
                  gradient: AppColors.lightPurpleGradient,
                ),
              ],
            ),
            6.heightBox,
            Row(
              children: [
                _ItemCard(
                  onTap: HapticFeedback.lightImpact,
                  icon: Icons.qr_code_outlined,
                  title: 'My Code',
                  subtitle: 'View My QRcode',
                  gradient: AppColors.greenGradient,
                ),
                _ItemCard(
                  onTap: HapticFeedback.lightImpact,
                  icon: Icons.qr_code_scanner_outlined,
                  title: 'QR Scanner',
                  subtitle: 'Scan QRcode',
                  gradient: AppColors.purpleGradient,
                ),
              ],
            ),
            6.heightBox,
            Row(
              children: [
                _ItemCard(
                  onTap: HapticFeedback.lightImpact,
                  icon: Icons.analytics_outlined,
                  title: 'Analytics',
                  subtitle: 'Accounts Stats',
                  gradient: AppColors.blueGradient,
                ),
                _ItemCard(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Get.to<void>(() => const MyProfileScreen());
                  },
                  icon: Icons.person_outline,
                  title: 'My Profile',
                  subtitle: 'View My Profile',
                  gradient: AppColors.orangeGradient,
                ),
              ],
            ),
            48.heightBox,
          ],
        ).px16().scrollVertical(),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.gradient,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final LinearGradient gradient;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 0.95,
        child: Stack(
          children: [
            InkWell(
              child: Card(
                shape: Vx.withRounded(12),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.heightBox,
                      Icon(
                        icon,
                        size: 24,
                        color: Colors.white,
                        // width: 32,
                        // height: 32,
                      ).pOnly(left: 16, top: 12),
                      12.heightBox,
                      title.text.white.medium.xl.make().px16(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            subtitle.text.white
                                .size(15.sp)
                                .maxLines(1)
                                .make()
                                .pOnly(top: 3)
                                .expand(),
                            Image.asset(
                              Images.nextArrow,
                              width: 24,
                              height: 24,
                            )
                          ],
                        ).p8(),
                      ).expand(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -12,
              right: -12,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              right: 40,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              right: 60,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    ).expand();
  }
}
