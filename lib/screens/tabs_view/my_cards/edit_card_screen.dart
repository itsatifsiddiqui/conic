import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conic/models/app_user.dart';
import 'package:conic/providers/app_user_provider.dart';
import 'package:conic/providers/firebase_storage_provider.dart';
import 'package:conic/res/app_colors.dart';
import 'package:conic/res/validators.dart';
import 'package:conic/services/image_picker_service.dart';
import 'package:conic/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
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
    selectedCardModel = widget.cardModel.copyWith();
    _titleController = TextEditingController(text: selectedCardModel.name ?? '');
    _descriptionController = TextEditingController(text: selectedCardModel.description ?? '');
    super.initState();
  }

  updateData(BuildContext context, AppUser user) async {
    isLoading = true;
    setState(() {});
    // print(true);
    selectedCardModel.name = _titleController.text;
    selectedCardModel.description = _descriptionController.text;
    selectedCardModel.accounts = context.read(addAccountsList).state;
    print(selectedCardModel.name);
    print(widget.cardModel.name);
    print(selectedCardModel.name == context.read(selectedCard).state!.name);
    if (selectedCardModel != widget.cardModel || selectedImage != null) {
      print(true);
      if (selectedImage != null) {
        String? image;
        final path = 'cards';
        image = (await context.read(firebaseStorageProvider).uploadFile(selectedImage!, path));
        selectedCardModel.photo = image;
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.userId)
          .collection('cards')
          .doc(selectedCardModel.docId)
          .set(selectedCardModel.toMap());
    }
    context.read(selectedCard).state = selectedCardModel;
    isLoading = false;
    setState(() {});
    // Get.back();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    context.read(addAccountsList).state = [];
    super.dispose();
  }

  List<String> colorsList = ['', 'green', 'red', 'purple', 'pink', 'yehllow', 'blue'];
  late CardModel selectedCardModel;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer(
      builder: (context, watch, child) {
        final accounts = watch(appUserProvider)!.linkedAccounts;
        final user = watch(appUserProvider);
        watch(addAccountsList).state;
        return DefaultTabController(
          length: 2,
          child: LoadingOverlay(
            isLoading: isLoading,
            child: Scaffold(
              appBar: AppBar(
                title: 'Edit Card'.text.semiBold.color(Theme.of(context).dividerColor).make(),
                centerTitle: true,
                actions: [
                  Center(
                    child: GestureDetector(
                        onTap: () {
                          updateData(context, user!);
                        },
                        child: 'Save'.text.size(16).semiBold.color(AppColors.primaryColor).make()),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ],
                bottom: TabBar(
                  tabs: [
                    Tab(
                      child: selectedCardModel.name!.text.make(),
                    ),
                    Tab(
                      child: 'Customize'.text.make(),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  SizedBox(
                    height: size.height,
                    width: size.width,
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              color: selectedCardModel.theme == 'red'
                                  ? Colors.red
                                  : selectedCardModel.theme == 'green'
                                      ? Colors.green
                                      : selectedCardModel.theme == 'purple'
                                          ? Colors.purple
                                          : selectedCardModel.theme == 'pink'
                                              ? Colors.pink
                                              : selectedCardModel.theme == 'yehllow'
                                                  ? Colors.yellow
                                                  : selectedCardModel.theme == 'blue'
                                                      ? Colors.blue
                                                      : null,
                              width: double.infinity,
                              child: const SizedBox(
                                height: 30,
                              ),
                            ),
                            Container(
                              color: selectedCardModel.theme == 'red'
                                  ? Colors.red
                                  : selectedCardModel.theme == 'green'
                                      ? Colors.green
                                      : selectedCardModel.theme == 'purple'
                                          ? Colors.purple
                                          : selectedCardModel.theme == 'pink'
                                              ? Colors.pink
                                              : selectedCardModel.theme == 'yehllow'
                                                  ? Colors.yellow
                                                  : selectedCardModel.theme == 'blue'
                                                      ? Colors.blue
                                                      : null,
                              width: double.infinity,
                              child: Center(
                                child: Stack(
                                  children: [
                                    selectedImage != null
                                        ? Container(
                                            child: Container(
                                              height: 150,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                image:
                                                    DecorationImage(image: FileImage(selectedImage!), fit: BoxFit.fill),
                                              ),
                                            ),
                                          )
                                        : selectedCardModel.photo != null
                                            ? Container(
                                                height: 150,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(selectedCardModel.photo!), fit: BoxFit.fill),
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
                              ),
                            ),
                            Container(
                              color: selectedCardModel.theme == 'red'
                                  ? Colors.red
                                  : selectedCardModel.theme == 'green'
                                      ? Colors.green
                                      : selectedCardModel.theme == 'purple'
                                          ? Colors.purple
                                          : selectedCardModel.theme == 'pink'
                                              ? Colors.pink
                                              : selectedCardModel.theme == 'yehllow'
                                                  ? Colors.yellow
                                                  : selectedCardModel.theme == 'blue'
                                                      ? Colors.blue
                                                      : null,
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 20),
                              child: const SizedBox(
                                height: 30,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: FilledTextField(
                                controller: _titleController,
                                title: 'Title',
                                validator: Validators.emptyValidator,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: FilledTextField(controller: _descriptionController, title: 'Description'),
                            ),
                            const SizedBox(
                              height: 35,
                            ),
                            PrimaryButton(
                              onTap: () {
                                Get.to<void>(() => AddSocialAccountScreen());
                              },
                              color: selectedCardModel.theme == 'red'
                                  ? Colors.red
                                  : selectedCardModel.theme == 'green'
                                      ? Colors.green
                                      : selectedCardModel.theme == 'purple'
                                          ? Colors.purple
                                          : selectedCardModel.theme == 'pink'
                                              ? Colors.pink
                                              : selectedCardModel.theme == 'yehllow'
                                                  ? Colors.yellow
                                                  : selectedCardModel.theme == 'blue'
                                                      ? Colors.blue
                                                      : null,
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
                                    if (context.read(addAccountsList).state.contains(e.fullLink))
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
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        runSpacing: 15,
                        spacing: size.width * 0.02,
                        children: colorsList
                            .map(
                              (e) => GestureDetector(
                                onTap: () {
                                  selectedCardModel.theme = e;
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 5,
                                      color: selectedCardModel.theme == e ? Colors.green : Colors.transparent,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
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
                                                            : e == 'blue'
                                                                ? Colors.blue
                                                                : Colors.white,
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
          ),
        );
      },
    );
  }
}
