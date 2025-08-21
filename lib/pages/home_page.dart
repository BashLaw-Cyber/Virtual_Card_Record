import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vcard/pages/contact_detail_page.dart';
import 'package:vcard/pages/scan_page.dart';
import 'package:vcard/providers/contact_provider.dart';
import 'package:vcard/utils/helper_function.dart';

class HomePage extends StatefulWidget {
  static final String routeName = "/";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedItem = 0;
  bool isScanOver = false;
  List<String> lines = [];
  String image = "";

  get menuItem => ListView(
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.code)),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
            ),
          )
        ],
      );

  @override
  void didChangeDependencies() {
    Provider.of<ContactProvider>(context, listen: false).getAllContacts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        backgroundColor: Colors.white10,
        actions: [
          IconButton(
              onPressed: () {
                getImage(ImageSource.camera);
              },
              icon: Icon(Icons.camera_alt_outlined)),
          PopupMenuButton<String>(
            color: Colors.white,
            padding: EdgeInsets.zero,
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case "Profile":
                  break;
                case "Scan":
                  context.goNamed(ScanPage.route);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "Profile",
                child: Text("Profile"),
              ),
              PopupMenuItem(
                value: "Scan",
                child: Text("Scan QRCode"),
              ),
              PopupMenuItem(
                value: "Setting",
                child: Text("Setting"),
              ),
              PopupMenuItem(
                value: "Logout",
                child: Text("Logout"),
              ),
            ],
          ),
        ],
        title: Text("Contact List"),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.green[300],
            onTap: (value) {
              setState(() {
                selectedItem = value;
              });
              _fetchData();
            },
            currentIndex: selectedItem,
            items: [
              BottomNavigationBarItem(
                icon: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    color: Colors.green,
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                    )),
                label: "All",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "Favorite",
              )
            ]),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.contactList.length,
          itemBuilder: (context, index) {
            final contact = provider.contactList[index];
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: FractionalOffset.centerRight,
                //Alignment.centerRight,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), color: Colors.red),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              confirmDismiss: (direction) {
                return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Delete contact"),
                    content: Text("$deleteMsg ${contact.name.toLowerCase()} ?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            provider.deleteContact(contact.id);
                            provider.getAllContacts();
                            context.pop();
                          },
                          child: Text("Yes")),
                      TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: Text("No")),
                    ],
                  ),
                );
              },
              child: ListTile(
                onTap: () => context.goNamed(ContactDetailPage.routeName,
                    extra: contact.id),
                title: Text(contact.name),
                trailing: IconButton(
                    onPressed: () {
                      provider.updateFavorite(contact);
                    },
                    icon: Icon(contact.favorite
                        ? Icons.favorite
                        : Icons.favorite_border)),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Icon(
            Icons.add_comment_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            context.goNamed(ScanPage.route);
          }),
    );
  }

  void getImage(ImageSource camera) async {
    final xFile = await ImagePicker().pickImage(
      source: camera,
    );

    if (xFile != null) {
      setState(() {
        image = xFile.path;
      });
      EasyLoading.show(status: "Please wait");
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final recognizedText = await textRecognizer
          .processImage(InputImage.fromFile(File(xFile.path)));
      EasyLoading.dismiss();

      final tempList = <String>[];

      for (var block in recognizedText.blocks) {
        for (var line in block.lines) {
          tempList.add(line.text);
        }
      }
      setState(() {
        lines = tempList;
        isScanOver = true;
      });
    }
  }

  void _fetchData() {
    switch (selectedItem) {
      case 0:
        Provider.of<ContactProvider>(context, listen: false).getAllContacts();
        break;
      case 1:
        Provider.of<ContactProvider>(context, listen: false)
            .getAllFavoriteContacts();
        break;
    }
  }
}
