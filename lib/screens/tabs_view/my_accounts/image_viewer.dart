import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../res/res.dart';

class ImageViewer extends HookWidget {
  const ImageViewer({
    Key? key,
    required this.url,
  }) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    //Disable hero effect from this screen.
    //Having hero on pop cause picture to animate as zoom out.
    final heroEnabled = useState(true);
    useEffect(() {
      Future<void>.delayed(250.milliseconds, () => heroEnabled.value = false);
    });
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // leading: const BackButton(color: Colors.white),
      ),
      body: InteractiveViewer(
        alignPanAxis: true,
        child: HeroMode(
          enabled: heroEnabled.value,
          child: Hero(
            tag: url,
            child: CachedNetworkImage(
              imageUrl: url,
              height: double.infinity,
              placeholder: kImagePlaceHodler,

              // fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
