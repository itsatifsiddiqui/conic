import 'package:conic/models/app_user.dart';
import 'package:conic/providers/app_user_provider.dart';
import 'package:conic/providers/firestore_provider.dart';
import 'package:conic/screens/tabs_view/dashboard/my_connections/user_list_item.dart';
import 'package:conic/screens/tabs_view/dashboard/search/search_users_screen.dart';
import 'package:conic/widgets/adaptive_progress_indicator.dart';
import 'package:conic/widgets/error_widet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../res/res.dart';

// final followRequestsStateProvider = StateProvider<AsyncValue<List<AppUser>>>((ref) {
//   return const AsyncValue.loading();
// });

final followRequestsRecievedProvider = StreamProvider.autoDispose<List<AppUser>>((ref) {
  final userId = ref.watch(appUserProvider)?.userId;
  final followRequestsRecieved = ref.watch(appUserProvider)?.followRequestsRecieved ?? [];
  if (userId == null) {
    // ref.read(followRequestsStateProvider).state = const AsyncValue.data(<AppUser>[]);
    return Stream.value(<AppUser>[]);
  }

  // final stateData =
  //     ref.read(followRequestsStateProvider).state.data ?? const AsyncData(<AppUser>[]);

  // if (stateData.value.isEmpty) {
  //   final requests =
  //       await ref.read(firestoreProvider).getFollowRequestsLessAbove10(followRequestsRecieved);
  //   ref.read(followRequestsStateProvider).state = AsyncValue.data(requests);
  // }

  // if (followRequestsRecieved.length <= 10) {
  //   return ref.read(firestoreProvider).getFollowRequestsLessThan10(followRequestsRecieved);
  // }
  return ref.read(firestoreProvider).getFollowRequestsLessAbove10(followRequestsRecieved);
});

class FollowRequestsScreen extends HookWidget {
  const FollowRequestsScreen({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final currentUserId = useProvider(appUserProvider.select((value) => value!.userId))!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: 'Follow Requests'.text.xl.color(context.adaptive).make(),
      ),
      body: useProvider(followRequestsRecievedProvider).when(
        data: (requests) {
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final user = requests[index];

              return ConfirmationButtons(
                appUser: user,
                currentUserId: currentUserId,
              );

              return UserListItem(
                image: user.image,
                username: user.username!,
                name: user.name!,
                trailing: ConfirmationButtons(
                  appUser: user,
                  currentUserId: currentUserId,
                ),
              );
              return HookBuilder(
                builder: (context) {
                  final isAccepted = useState<bool?>(null);
                  if (isAccepted.value == false) {
                    return const SizedBox();
                  }
                  // return UserListItem(
                  //   image: user.image,
                  //   username: user.username!,
                  //   name: user.name!,
                  //   trailing: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children:,
                  //   ),
                  // );
                },
              );
            },
          );
        },
        loading: () => const AdaptiveProgressIndicator(),
        error: (e, s) {
          return StreamErrorWidget(
            error: e.toString(),
            onTryAgain: () {
              context.refresh(followRequestsRecievedProvider);
            },
          );
        },
      ),
    );
  }
}

class ConfirmationButtons extends StatefulHookWidget {
  const ConfirmationButtons({
    Key? key,
    required this.appUser,
    required this.currentUserId,
  }) : super(key: key);
  final AppUser appUser;
  final String currentUserId;

  @override
  _ConfirmationButtonsState createState() => _ConfirmationButtonsState();
}

class _ConfirmationButtonsState extends State<ConfirmationButtons> {
  late AppUser otherUser;
  bool? hasAccepted;

  @override
  void initState() {
    super.initState();
    otherUser = widget.appUser;
  }

  @override
  Widget build(BuildContext context) {
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasAccepted == true)
          SendRequestButton(
            appUser: otherUser,
            currentUserId: widget.currentUserId,
            followback: true,
          ),
        // HookBuilder(
        //   builder: (context) {
        //     return OutlinedButton(
        //       style: OutlinedButton.styleFrom(
        //         padding: const EdgeInsets.all(8),
        //         // backgroundColor: hasRequestSent ? null : context.primaryColor,
        //       ),
        //       onPressed: () async {
        //         // if (hasRequestSent) {
        //         //   context.read(firestoreProvider).unSendFollowRequest(user.userId!);
        //         // } else {
        //         //   context.read(firestoreProvider).sendFollowRequest(user.userId!);
        //         // }
        //       },
        //       child: ' Follow Back'.text.sm.medium.make(),
        //     );
        //   },
        // ),
        if (hasAccepted == null)
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(8),
              backgroundColor: context.primaryColor,
            ),
            onPressed: () async {
              hasAccepted = true;
              setState(() {});
              // context.read(firestoreProvider).confirmFollowRequest(user.userId!);
            },
            child: 'Confrim'.text.sm.medium.color(Colors.white).make(),
          ),
        4.widthBox,
        if (hasAccepted == null)
          OutlinedButton(
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(8)),
            onPressed: () async {
              hasAccepted = false;
              setState(() {});
              context.read(firestoreProvider).discardFolowRequest(otherUser.userId!);
            },
            child: 'Discard'.text.sm.color(context.primaryColor).make(),
          ),
      ],
    );

    if (hasAccepted == false) {
      return const SizedBox();
    }

    return UserListItem(
      image: widget.appUser.image,
      username: widget.appUser.username!,
      name: widget.appUser.name!,
      trailing: row,
    );
  }
}
