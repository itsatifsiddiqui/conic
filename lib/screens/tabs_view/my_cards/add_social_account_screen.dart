import 'package:conic/providers/app_user_provider.dart';
import 'package:conic/res/res.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'add_card_screen.dart';

class AddSocialAccountScreen extends StatefulWidget {
  AddSocialAccountScreen({Key? key}) : super(key: key);

  @override
  _AddSocialAccountScreenState createState() => _AddSocialAccountScreenState();
}

class _AddSocialAccountScreenState extends State<AddSocialAccountScreen> {
  List<String> selectedAcconts = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    selectedAcconts = context.read(addAccountsList).state;
    return Consumer(
      builder: (context, watch, child) {
        final accounts = watch(appUserProvider)!.linkedAccounts;
        return Scaffold(
          appBar: AppBar(
            actions: [
              GestureDetector(
                onTap: () {
                  context.read(addAccountsList).state = selectedAcconts;
                  print(context.read(addAccountsList).state);
                  Get.back();
                },
                child: Center(
                  child: 'Done'.text.bold.color(context.primaryColor).size(16).make(),
                ),
              ),
              SizedBox(
                width: 15,
              ),
            ],
            title: 'Link Accounts'.text.color(Theme.of(context).dividerColor).size(18).bold.make(),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: ListView.builder(
                itemBuilder: (context, index) => CheckboxListTile(
                  value: selectedAcconts.contains(accounts![index].fullLink ?? ''),
                  onChanged: (val) {
                    print(val);
                    if (!val!)
                      selectedAcconts.remove(accounts[index].fullLink!);
                    else
                      selectedAcconts.add(accounts[index].fullLink!);
                    setState(() {});
                  },
                  title: accounts[index].name.text.color(Theme.of(context).dividerColor).make(),
                  secondary: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(accounts[index].image),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                itemCount: accounts!.length,
              ),
            ),
          ),
        );
      },
    );
  }
}
