import 'package:conic/models/app_user.dart';
import 'package:conic/providers/app_user_provider.dart';
import 'package:conic/providers/firestore_provider.dart';
import 'package:conic/screens/tabs_view/dashboard/my_connections/user_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../res/res.dart';

class FollowRequestsScreen extends StatelessWidget {
  const FollowRequestsScreen({Key? key, required this.requests}) : super(key: key);
  final List<AppUser> requests;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: 'Follow Requests'.text.xl.color(context.adaptive).make(),
      ),
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final user = requests[index];
          return HookBuilder(
            builder: (context) {
              final isAccepted = useState<bool?>(null);
              if (isAccepted.value == false) {
                return const SizedBox();
              }
              return UserListItem(
                image: user.image,
                username: user.username!,
                name: user.name!,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // if (isAccepted.value == true)
                    // HookBuilder(
                    //   builder: (context) {
                    //     final sentRequests =
                    //         useProvider(appUserProvider.select((value) => value!.sentRequests)) ??
                    //             [];
                    //     final hasRequestSent = sentRequests.contains(user.userId);
                    //     return OutlinedButton(
                    //       style: OutlinedButton.styleFrom(
                    //         padding: const EdgeInsets.all(8),
                    //         backgroundColor: hasRequestSent ? null : context.primaryColor,
                    //       ),
                    //       onPressed: () async {
                    //         if (hasRequestSent) {
                    //           context.read(firestoreProvider).unSendFollowRequest(user.userId!);
                    //         } else {
                    //           context.read(firestoreProvider).sendFollowRequest(user.userId!);
                    //         }
                    //       },
                    //       child: (hasRequestSent ? 'Requested' : ' Follow Back')
                    //           .text
                    //           .sm
                    //           .medium
                    //           .color(hasRequestSent ? context.primaryColor : Colors.white)
                    //           .make(),
                    //     );

                    //     // return OutlinedButton(
                    //     //   onPressed: () {
                    //     // if (hasRequestSent) {
                    //     //   context.read(firestoreProvider).unSendFollowRequest(data.userId!);
                    //     // } else {
                    //     //   context.read(firestoreProvider).sendFollowRequest(data.userId!);
                    //     // }
                    //     //   },
                    //     //   child: (hasRequestSent ? 'Requested' : 'Follow')
                    //     //       .text
                    //     //       .sm
                    //     //       .color(context.primaryColor)
                    //     //       .make(),
                    //     // );
                    //   },
                    // ),
                    if (isAccepted.value == null)
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(8),
                          backgroundColor: context.primaryColor,
                        ),
                        onPressed: () async {
                          isAccepted.value = true;
                          context.read(firestoreProvider).confirmFollowRequest(user.userId!);
                        },
                        child: 'Confrim'.text.sm.medium.color(Colors.white).make(),
                      ),
                    4.widthBox,
                    if (isAccepted.value == null)
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(8)),
                        onPressed: () async {
                          isAccepted.value = false;
                          context.read(firestoreProvider).discardFolowRequest(user.userId!);
                        },
                        child: 'Discard'.text.sm.color(context.primaryColor).make(),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
