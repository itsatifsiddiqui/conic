import 'package:conic/screens/tabs_view/my_accounts/add_media_sheet.dart';
import 'package:flutter/material.dart';

import '../res/res.dart';
import 'primary_button.dart';

class NoMediasWidget extends StatelessWidget {
  const NoMediasWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black12,
      elevation: 12,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 2 / 1,
                  child: Container(
                    color: context.adaptive12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          size: 48,
                          color: context.adaptive,
                        ),
                        12.widthBox,
                        Icon(
                          Icons.video_collection_rounded,
                          size: 48,
                          color: context.adaptive,
                        ),
                        12.widthBox,
                        Icon(
                          Icons.picture_as_pdf,
                          size: 48,
                          color: context.adaptive,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          12.heightBox,
          'Get started by adding your first media'.text.xl.center.semiBold.makeCentered().px16(),
          'Tap on button below or add icon above the card to add media to your profile.\n\n You can add image, video and pdf.\n\nMedias added to your profile can be shared instantly.'
              .text
              .center
              .color(context.adaptive70)
              .makeCentered()
              .p12(),
          PrimaryButton(
            text: 'Add media',
            onTap: () {
              AddMediaSheet.openMediaSheet(context);
            },
          ).p12(),
        ],
      ),
    );
  }
}
