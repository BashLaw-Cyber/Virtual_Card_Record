import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vcard/models/contact_model.dart';
import 'package:vcard/pages/form_page.dart';
import 'package:vcard/utils/constants.dart';

class ScanPage extends StatefulWidget {
  static final String route = "scan";

  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool isScanOver = false;
  List<String> lines = [];
  String name = "",
      mobile = "",
      email = "",
      address = "",
      company = "",
      designation = "",
      website = "",
      image = "";

  void createContact() {
    final contact = ContactModel(
      name: name,
      mobile: mobile,
      email: email,
      address: address,
      company: company,
      image: image,
      website: website,
      designation: designation,
    );
    context.goNamed(FormPage.routeName, extra: contact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: image.isEmpty ? null : createContact,
            icon: Icon(Icons.arrow_forward),
          )
        ],
        title: Text("Scan Page"),
      ),
      body: ListView(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () {
                getImage(ImageSource.camera);
              },
              label: Text("Capture"),
              icon: Icon(Icons.camera),
            ),
            TextButton.icon(
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              label: Text("Gallery"),
              icon: Icon(Icons.photo),
            )
          ],
        ),
        Wrap(children: lines.map((line) => LineItem(line: line)).toList()),
        if (isScanOver)
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              ContactProperties.hint,
              style: TextStyle(color: Colors.amber),
            ),
          ),
        if (isScanOver)
          Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  DragTargetItem(
                      property: ContactProperties.name,
                      onDrop: getPropertyValue),
                  DragTargetItem(
                      property: ContactProperties.mobile,
                      onDrop: getPropertyValue),
                  DragTargetItem(
                      property: ContactProperties.email,
                      onDrop: getPropertyValue),
                  DragTargetItem(
                      property: ContactProperties.company,
                      onDrop: getPropertyValue),
                  DragTargetItem(
                      property: ContactProperties.designation,
                      onDrop: getPropertyValue),
                  DragTargetItem(
                      property: ContactProperties.address,
                      onDrop: getPropertyValue),
                  DragTargetItem(
                      property: ContactProperties.website,
                      onDrop: getPropertyValue)
                ],
              ),
            ),
          )
      ]),
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

  getPropertyValue(String property, String value) {
    switch (property) {
      case ContactProperties.name:
        name = value;
        break;
      case ContactProperties.mobile:
        mobile = value;
        break;
      case ContactProperties.email:
        email = value;
        break;
      case ContactProperties.address:
        address = value;
        break;
      case ContactProperties.company:
        company = value;
        break;
      case ContactProperties.designation:
        designation = value;
        break;
      case ContactProperties.website:
        website = value;
        break;
    }
  }
}

class LineItem extends StatelessWidget {
  final String line;

  const LineItem({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      data: line,
      dragAnchorStrategy: childDragAnchorStrategy,
      feedback: Container(
        key: GlobalKey(),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(color: Colors.black45),
        child: Text(
          line,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
      ),
      child: Chip(label: Text(line)),
    );
  }
}

class DragTargetItem extends StatefulWidget {
  final String property;
  final Function(String, String) onDrop;

  const DragTargetItem(
      {super.key, required this.property, required this.onDrop});

  @override
  State<DragTargetItem> createState() => _DragTargetItemState();
}

class _DragTargetItemState extends State<DragTargetItem> {
  String dragItem = "";

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Text(widget.property)),
        Expanded(
            flex: 2,
            child: DragTarget<String>(
              builder: (context, candidateData, rejectedData) => Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    border: candidateData.isNotEmpty
                        ? Border.all(color: Colors.red, width: 2)
                        : null),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(dragItem.isEmpty ?  "Drop here" : dragItem)),
                    if (dragItem.isNotEmpty)
                      InkWell(
                        onTap: () {
                          setState(() {
                            dragItem = "";
                          });
                        },
                        child: Icon(
                          Icons.clear,
                          size: 15,
                        ),
                      )
                  ],
                ),
              ),
              onAccept: (data) {
                setState(() {
                  if (dragItem.isEmpty) {
                    dragItem = data;
                  } else {
                    dragItem += " $data";
                  }
                });
                widget.onDrop(widget.property, dragItem);
              },
            ))
      ],
    );
  }
}
