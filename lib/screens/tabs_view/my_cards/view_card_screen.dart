import 'package:flutter/material.dart';
import '../../../res/res.dart';
import '../../../widgets/accounts_builder.dart';

class ViewCardScreen extends StatelessWidget {
  const ViewCardScreen({
    Key? key,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);
  final String title;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: title.text.semiBold.color(context.adaptive).make(),
        centerTitle: true,
        actions: [
          Center(
            child: 'Edit'.text.size(16).semiBold.color(AppColors.primaryColor).make(),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Image.asset(
                    imageUrl,
                    height: size.height * 0.2,
                    width: size.width * 0.34,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const DisplayInformationWidget(
                  subTitle: 'Personal Card',
                  title: 'Title',
                ),
                const SizedBox(
                  height: 20,
                ),
                const DisplayInformationWidget(
                  subTitle: 'Attock',
                  title: 'Location',
                ),
                const SizedBox(
                  height: 20,
                ),
                const DisplayInformationWidget(
                  subTitle: 'This is my personel card',
                  title: 'Description',
                ),
                const SizedBox(
                  height: 30,
                ),
                'Linked Accounts'.text.size(22).semiBold.color(context.adaptive).make(),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DisplayInformationWidget extends StatelessWidget {
  const DisplayInformationWidget({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);
  final String title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          title.text.size(22).semiBold.color(context.adaptive).make(),
          subTitle.text.size(14).color(AppColors.grey).make(),
        ],
      ),
    );
  }
}
