import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conic/providers/app_user_provider.dart';
import 'package:conic/providers/firestore_provider.dart';
import 'package:conic/res/res.dart';
import 'package:conic/widgets/adaptive_progress_indicator.dart';
import 'package:conic/widgets/error_widet.dart';
import 'package:conic/widgets/info_widget.dart';
import 'package:conic/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_animation/ripple_animation.dart';

final locationCheckerProvider = FutureProvider.autoDispose((ref) {
  return kCheckAndAskForLocationPermission();
});

final nearbyUsersProvider =
    StreamProvider.autoDispose.family<List<DocumentSnapshot<Object?>>, Position>((ref, position) {
  final geo = GeoFlutterFire();
  final center = geo.point(
    latitude: position.latitude,
    longitude: position.longitude,
  );
  final collectionReference = FirebaseFirestore.instance.collection('users');
  final stream = geo.collection(collectionRef: collectionReference).within(
        center: center,
        radius: 10,
        field: 'location',
      );

  return stream;
});

class FindNearbyScreen extends HookWidget {
  const FindNearbyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final username = useProvider(appUserProvider.select((value) => value!.username))!;
    final isVisible = useState(false);
    return WillPopScope(
      onWillPop: () {
        context.read(firestoreProvider).makeMeInVisible();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: 'Find Nearby'.text.xl.color(context.adaptive).make(),
        ),
        body: _LocationObserver(
          child: SafeArea(
            child: useProvider(locationCheckerProvider).when(
              data: (position) {
                if (position == null) {
                  return InfoWidget(
                    text: 'Location Permission is required',
                    subText: 'We need your location to find the nearby users',
                    tryAgainText: 'Give Permission',
                    onTryAgain: () {
                      context.refresh(locationCheckerProvider);
                    },
                  );
                }

                return Column(
                  children: [
                    Column(
                      children: [
                        Image.asset(Images.findNearby).p12(),
                        '@$username'.text.xl.semiBold.make(),
                        24.heightBox,
                        'Your profile will only appear to nearby members while on this page. To stay in the nearby list click the make me visible button.'
                            .text
                            .lg
                            .center
                            .color(context.adaptive70)
                            .make(),
                        Stack(
                          children: [
                            useProvider(nearbyUsersProvider(position)).when(
                              data: (docs) {
                                final filteredDocs = docs.where((element) =>
                                    (element.data()! as Map<String, dynamic>)['username'] !=
                                    username);
                                return filteredDocs.toString().text.make();
                              },
                              loading: () => const SizedBox(),
                              error: (e, s) => 'Error finding users'.text.makeCentered(),
                            ),
                            RippleAnimation(
                              repeat: true,
                              color: Colors.blue,
                              minRadius: 50,
                              ripplesCount: 6,
                              child: Container(),
                            )
                          ],
                        ).expand()
                      ],
                    ).px16().expand(),
                    PrimaryButton(
                      isOutline: isVisible.value,
                      text: 'Make me ${isVisible.value ? "Invisible" : "visible"}',
                      onTap: () async {
                        if (isVisible.value) {
                          isVisible.value = false;
                          context.read(firestoreProvider).makeMeInVisible();
                          return;
                        }
                        final result = await kCheckAndAskForLocationPermission();
                        if (result == false) return;

                        isVisible.value = true;

                        final location = await Geolocator.getCurrentPosition();
                        final geo = GeoFlutterFire();
                        final myLocation = geo.point(
                          latitude: location.latitude,
                          longitude: location.longitude,
                        );

                        context.read(firestoreProvider).makeMeVisible(myLocation);
                      },
                    ).p16(),
                  ],
                );
              },
              loading: () => const AdaptiveProgressIndicator(),
              error: (e, s) {
                return StreamErrorWidget(
                  error: e.toString(),
                  onTryAgain: () {
                    context.refresh(locationCheckerProvider);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _LocationObserver extends StatefulWidget {
  const _LocationObserver({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  _LocationObserverState createState() => _LocationObserverState();
}

// ignore: prefer_mixin
class _LocationObserverState extends State<_LocationObserver> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('didChangeAppLifecycleState');
    debugPrint(state.toString());
    if (state == AppLifecycleState.resumed) {
      onResume();
    } else {
      context.read(firestoreProvider).makeMeInVisible();
    }
  }

  Future onResume() async {
    // ignore: unawaited_futures
    context.refresh(locationCheckerProvider);
    final location = await Geolocator.getCurrentPosition();
    final geo = GeoFlutterFire();
    final myLocation = geo.point(
      latitude: location.latitude,
      longitude: location.longitude,
    );

    context.read(firestoreProvider).makeMeVisible(myLocation);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
}
