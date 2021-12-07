import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conic/models/card_model.dart';
import 'package:conic/providers/app_user_provider.dart';
import 'package:conic/providers/firebase_storage_provider.dart';
import 'package:conic/res/validators.dart';
import 'package:conic/screens/add_account/account_form_screen.dart';
import 'package:conic/screens/add_account/add_new_account_screen.dart';
import 'package:conic/screens/tabs_view/my_cards/add_social_account_screen.dart';
import 'package:conic/services/dynamic_link_generator.dart';
import 'package:conic/services/image_picker_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../../../res/res.dart';
import '../../../widgets/custom_widgets.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({Key? key}) : super(key: key);

  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

final addAccountsList = StateProvider<List<String>>((ref) => []);

class _AddCardScreenState extends State<AddCardScreen> {
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    context.read(addAccountsList).state = [];
    super.dispose();
  }

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  File? selectedImage;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(context.read(addAccountsList).state);
    return Consumer(
      builder: (context, watch, child) {
        final addedAccounts = watch(addAccountsList).state;
        final accounts = watch(appUserProvider)!.linkedAccounts;
        final user = watch(appUserProvider);
// DynamicLinkGenerator()
        return LoadingOverlay(
          isLoading: isLoading,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        isLoading = true;
                      });
                      var ref =
                          FirebaseFirestore.instance.collection('users').doc(user!.userId).collection('cards').doc().id;
                      final generatedLink = await DynamicLinkGenerator(
                        isCard: true,
                        userId: user.userId!,
                        username: user.username!,
                        isAndroidLink: Platform.isAndroid,
                        isProfile: true,
                      ).generateDynamicLink();
                      print(generatedLink);
                      String? image;
                      if (selectedImage != null) {
                        final path = 'cards';
                        image = (await context.read(firebaseStorageProvider).uploadFile(selectedImage!, path));
                      }
                      final cardAdded = CardModel(
                        accounts: addedAccounts,
                        description: _descriptionController.text,
                        docId: ref,
                        link: generatedLink,
                        name: _titleController.text,
                        photo: image,
                        theme: '',
                      );
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.userId)
                          .collection('cards')
                          .doc(ref)
                          .set(cardAdded.toMap());
                      setState(() {
                        isLoading = false;
                      });
                      Get.back();
                    }
                  },
                  icon: const Icon(
                    Icons.done,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            body: SizedBox(
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
                                if (addedAccounts.contains(e.fullLink))
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
          ),
        );
      },
    );
  }
}
