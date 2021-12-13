import 'dart:io';

import 'package:conic/providers/app_user_provider.dart';
import 'package:conic/res/app_colors.dart';
import 'package:conic/res/validators.dart';
import 'package:conic/screens/tabs_view/tabs_view.dart';
import 'package:conic/services/image_picker_service.dart';
import 'package:conic/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:conic/models/card_model.dart';

import 'add_card_screen.dart';
import 'add_social_account_screen.dart';
import 'my_cards_tab.dart';

class EditCardScreen extends StatefulWidget {
  EditCardScreen({
    Key? key,
    required this.cardModel,
  }) : super(key: key);
  final CardModel cardModel;
  @override
  _EditCardScreenState createState() => _EditCardScreenState();
}

class _EditCardScreenState extends State<EditCardScreen> with SingleTickerProviderStateMixin {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  File? selectedImage;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    selectedCardModel = widget.cardModel;
    _titleController = TextEditingController(text: selectedCardModel!.name ?? '');
    _descriptionController = TextEditingController(text: selectedCardModel!.description ?? '');
    super.initState();
  }

  late TabController _tabController;
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    context.read(addAccountsList).state = [];
    super.dispose();
  }

  List<String> colorsList = ['green', 'red', 'purple', 'pink', 'yehllow', 'blue'];
  CardModel? selectedCardModel;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer(
      builder: (context, watch, child) {
        final card = watch(selectedCard).state;
        final accounts = watch(appUserProvider)!.linkedAccounts;
        final user = watch(appUserProvider);
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: 'Edit Card'.text.semiBold.color(Theme.of(context).dividerColor).make(),
              centerTitle: true,
              actions: [
                Center(
                  child: GestureDetector(
                      onTap: () {}, child: 'Save'.text.size(16).semiBold.color(AppColors.primaryColor).make()),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
              bottom: TabBar(tabs: [
                Tab(
                  child: selectedCardModel!.name!.text.make(),
                ),
                Tab(
                  child: 'Customize'.text.make(),
                ),
              ]),
            ),
            body: TabBarView(
              children: [
                SizedBox(
                  height: size.height,
                  width: size.width,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Stack(
                              children: [
                                selectedImage != null
                                    ? Container(
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(image: FileImage(selectedImage!), fit: BoxFit.fill),
                                        ),
                                      )
                                    : selectedCardModel!.photo != null
                                        ? Container(
                                            height: 150,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(selectedCardModel!.photo!), fit: BoxFit.fill),
                                            ),
                                          )
                                        : const Icon(
                                            Icons.photo_camera,
                                            size: 150,
                                          ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () async {
                                        final imagePicerService = ImagePickerService();
                                        final file = await imagePicerService.pickImage();
                                        if (file != null) {
                                          selectedImage = File(file.path);
                                          setState(() {});
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        size: 30,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            FilledTextField(
                              controller: _titleController,
                              title: 'Title',
                              validator: Validators.emptyValidator,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FilledTextField(controller: _descriptionController, title: 'Description'),
                            const SizedBox(
                              height: 35,
                            ),
                            PrimaryButton(
                              onTap: () {
                                Get.to<void>(() => AddSocialAccountScreen());
                              },
                              width: size.width * 0.5,
                              text: 'Add Social Account',
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Wrap(
                                spacing: 6,
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                runAlignment: WrapAlignment.start,
                                runSpacing: 10,
                                children: accounts!.map(
                                  (e) {
                                    if (selectedCardModel!.accounts!.contains(e.fullLink))
                                      return Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(e.image),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      );
                                    else
                                      return Container(width: 0, height: 0);
                                  },
                                ).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: 25,
                      spacing: size.width * 0.05,
                      children: colorsList
                          .map(
                            (e) => GestureDetector(
                              onTap: () {
                                selectedCardModel!.theme = e;

                                setState(() {});
                              },
                              child: Container(
                                height: size.height * 0.3,
                                width: size.width * 0.4,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: e == 'red'
                                      ? Colors.red
                                      : e == 'green'
                                          ? Colors.green
                                          : e == 'purple'
                                              ? Colors.purple
                                              : e == 'pink'
                                                  ? Colors.pink
                                                  : e == 'yehllow'
                                                      ? Colors.yellow
                                                      : Colors.blue,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.blueGrey.withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(10)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
