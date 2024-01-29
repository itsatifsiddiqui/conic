// import 'dart:async';
// import 'dart:io';

// import 'package:conic/models/app_user.dart';
// import 'package:conic/providers/app_user_provider.dart';
// import 'package:conic/res/app_colors.dart';
// import 'package:conic/res/images.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:velocity_x/velocity_x.dart';

// class AnalyticsScreen extends StatefulWidget {
//   const AnalyticsScreen({Key? key}) : super(key: key);

//   @override
//   _AnalyticsScreenState createState() => _AnalyticsScreenState();
// }

// class _AnalyticsScreenState extends State<AnalyticsScreen> {
//   LatLng? currentPostion;

//   void _getUserLocation() async {
//     var position = await GeolocatorPlatform.instance
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     final image = Platform.isAndroid ? Images.heatMap : Images.heatMapApple;
//     print("IMAGE: $image");
//     await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)), image).then((d) {
//       customIcon = d;
//     });
//     setState(() {
//       currentPostion = LatLng(position.latitude, position.longitude);
//       isLoading = false;
//     });
//   }

//   Completer<GoogleMapController> _controller = Completer();
//   BitmapDescriptor? customIcon;
//   @override
//   void initState() {
//     super.initState();
//     _getUserLocation();
//   }

//   bool isLoading = true;
//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (context, watch, child) {
//         final user = watch(appUserProvider);
//         return Scaffold(
//           appBar: AppBar(
//             centerTitle: true,
//             title: 'Analytics'.text.xl.color(Theme.of(context).dividerColor).make(),
//           ),
//           body: SizedBox(
//             height: double.infinity,
//             width: double.infinity,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   30.heightBox,
//                   StreakRowWidget(
//                     title: '${user?.dayStreak?.toString() ?? 0} Day Streak',
//                     icon: Icon(
//                       Icons.local_fire_department,
//                       color: Colors.red,
//                     ),
//                   ),
//                   20.heightBox,
//                   StreakRowWidget(
//                     title: '${user!.nfcTaps?.toString() ?? 0} NFC taps',
//                     icon: Icon(
//                       Icons.visibility,
//                       color: AppColors.primaryColor,
//                     ),
//                   ),
//                   40.heightBox,
//                   'See on Map'.text.size(24).semiBold.color(Theme.of(context).dividerColor).make(),
//                   20.heightBox,
//                   Expanded(
//                     // height: size.height * 0.4,
//                     // width: double.infinity,
//                     // decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
//                     child: isLoading
//                         ? Center(
//                             child: CircularProgressIndicator(),
//                           )
//                         : GoogleMapsWidget(
//                             currentPostion: currentPostion,
//                             controller: _controller,
//                             customIcon: customIcon!,
//                             user: user,
//                           ),
//                   ),
//                   30.heightBox,
//                   'Top Accounts'
//                       .text
//                       .size(24)
//                       .semiBold
//                       .color(Theme.of(context).dividerColor)
//                       .make(),
//                   20.heightBox,
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: (user.linkedAccounts ?? [])
//                           .where((e) => (e.taps ?? 0) > 0)
//                           .take(4)
//                           .sortedByNum((e) => e.taps!)
//                           .reversed
//                           .map((e) {
//                         return Container(
//                           child: Column(
//                             children: [
//                               Container(
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(image: NetworkImage(e.image)),
//                                     borderRadius: BorderRadius.circular(5)),
//                               ),
//                               '${e.taps?.toString() ?? 0} taps'
//                                   .text
//                                   .size(14)
//                                   .semiBold
//                                   .color(Theme.of(context).dividerColor)
//                                   .make(),
//                             ],
//                           ),
//                         );
//                       }).toList()),
//                   40.heightBox,
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class GoogleMapsWidget extends StatefulWidget {
//   const GoogleMapsWidget({
//     Key? key,
//     required this.currentPostion,
//     required this.customIcon,
//     required this.user,
//     required Completer<GoogleMapController> controller,
//   })  : _controller = controller,
//         super(key: key);
//   final BitmapDescriptor customIcon;
//   final LatLng? currentPostion;
//   final AppUser user;
//   final Completer<GoogleMapController> _controller;
//   @override
//   _GoogleMapsWidgetState createState() => _GoogleMapsWidgetState();
// }

// class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {
//   getMarkers() {
//     if (widget.user.customLatLons != null || widget.user.customLatLons!.length != 0)
//       for (var i = 0; i < widget.user.customLatLons!.length; i++) {
//         print(widget.user.customLatLons![i].lat);
//         print(widget.user.customLatLons![i].lon);
//         markers.add(
//           Marker(
//             draggable: false,
//             markerId: MarkerId(i.toString()),
//             position: LatLng(
//               widget.user.customLatLons![i].lat,
//               widget.user.customLatLons![i].lon,
//             ),
//             icon: widget.customIcon,
//           ),
//         );
//       }

//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     getMarkers();
//   }

//   Set<Marker> markers = {};

//   @override
//   Widget build(BuildContext context) {
//     print(markers);
//     return GoogleMap(
//       markers: markers,
//       mapType: MapType.normal,
//       onMapCreated: (GoogleMapController controller) {
//         widget._controller.complete(controller);
//       },
//       initialCameraPosition: CameraPosition(
//         target: widget.currentPostion!,
//         zoom: 14,
//       ),
//     );
//   }
// }

// class StreakRowWidget extends StatelessWidget {
//   const StreakRowWidget({
//     Key? key,
//     required this.icon,
//     required this.title,
//   }) : super(key: key);
//   final Icon icon;
//   final String title;
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         icon,
//         10.widthBox,
//         title.text.size(18).semiBold.color(Theme.of(context).dividerColor).make(),
//         10.widthBox,
//         icon,
//       ],
//     );
//   }
// }
