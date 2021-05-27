import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../res/res.dart';

class UserListItem extends StatelessWidget {
  const UserListItem({
    Key? key,
    required this.image,
    required this.username,
    required this.name,
    this.trailing,
    this.onTap,
  }) : super(key: key);
  final String? image;
  final String username;
  final String name;
  final Widget? trailing;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: image == null
          ? CircleAvatar(
              backgroundColor: context.adaptive12,
              child: Icon(
                Icons.person,
                color: context.adaptive54,
              ),
            )
          : CachedNetworkImage(imageUrl: image!),
      title: '@$username'.text.make(),
      subtitle: name.text.make(),
      trailing: trailing,
    );
  }
}
