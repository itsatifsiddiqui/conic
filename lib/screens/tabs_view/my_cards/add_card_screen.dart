import 'package:conic/screens/add_account/add_new_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/res.dart';
import '../../../widgets/custom_widgets.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({Key? key}) : super(key: key);

  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
  }

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.back<void>();
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
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Stack(
                  children: [
                    const Icon(
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
                          onPressed: () {},
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
                FilledTextField(controller: _titleController, title: 'Title'),
                const SizedBox(
                  height: 15,
                ),
                FilledTextField(controller: _locationController, title: 'Location'),
                const SizedBox(
                  height: 15,
                ),
                FilledTextField(controller: _descriptionController, title: 'Description'),
                const SizedBox(
                  height: 35,
                ),
                PrimaryButton(
                  onTap: () {
                    Get.to<void>(() => const AddNewAccountScreen());
                  },
                  width: size.width * 0.5,
                  text: 'Add Social Account',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
