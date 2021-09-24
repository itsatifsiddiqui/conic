import 'package:cached_network_image/cached_network_image.dart';
import 'package:conic/res/constants.dart';
import 'package:flutter/material.dart';

class ProfileCircle extends StatelessWidget {
  const ProfileCircle({
    Key? key,
    required this.imagePath,
    this.isLocal = false,
    this.size,
    this.onTap,
  }) : super(key: key);

  final String imagePath;
  final bool isLocal;
  final Size? size;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size?.width ?? 42,
        height: size?.height ?? 42,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          shape: BoxShape.circle,
        ),
        child: Builder(
          builder: (context) {
            if (isLocal) {
              return Image.asset(imagePath);
            }

            return CachedNetworkImage(
              imageUrl: imagePath,
              placeholder: kImagePlaceHodler,
            );
          },
        ),
      ),
    );
  }
}
