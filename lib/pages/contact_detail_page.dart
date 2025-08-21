import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vcard/models/contact_model.dart';
import 'package:vcard/providers/contact_provider.dart';
import 'package:vcard/utils/helper_function.dart';

class ContactDetailPage extends StatefulWidget {
  static const routeName = "detail";
  final int id;

  const ContactDetailPage({super.key, required this.id});

  @override
  State<ContactDetailPage> createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  late int id;

  @override
  void initState() {
    id = widget.id;
    print(id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => FutureBuilder<ContactModel>(
          future: provider.getContactById(id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final contact = snapshot.data!;
              return ListView(
                padding: EdgeInsets.all(8),
                children: [
                  Image.file(
                    File(contact.image),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  ListTile(
                    title: Text(contact.mobile),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: (){
                          callContact(contact.mobile);
                        }, icon: Icon(Icons.call)),
                        IconButton(onPressed: (){
                          smsContact(contact.mobile);
                        }, icon: Icon(Icons.sms))
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(contact.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: (){
                          emailContact(contact.email);
                        }, icon: Icon(Icons.email)),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(contact.address),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: (){
                          _openMap(contact.address);
                        }, icon: Icon(Icons.location_on)),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(contact.website),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: (){
                          _openBrowser(contact.website);
                        }, icon: Icon(Icons.signal_wifi_connected_no_internet_4_sharp)),
                      ],
                    ),
                  )



                ],
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text("Fail to load data"),
              );
            }
            return const Center(
              child: Text("Please wait..."),
            );
          },
        ),
      ),
    );
  }

  void callContact(String mobile) async {
    final url = "tel:$mobile";
    if(await canLaunchUrlString(url)){
      await launchUrlString(url);
    }else{
      showMsg(context, "Could not perform this operation");
    }
  }

  void smsContact(String mobile) async {
    final url = "sms:$mobile";
    if(await canLaunchUrlString(url)){
      await launchUrlString(url);
    }else{
      showMsg(context, "could not perform this operation");
    }

  }

  void emailContact(String email) async{
    final url = "mailto:$email";
    if(await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }else{
      showMsg(context, "Could not perform this operation");
    }
  }
  void _openMap(String loc) async{
    String url = "";
    if(Platform.isAndroid){
      url = "geo:0,0?q=$loc";
    }else{
      url = "http://maps.apple.com/?q=$loc";
    }
    if(await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }else{
      showMsg(context, "Could not perform this operation");
    }
  }

  void _openBrowser(String website) async {
    final url = "https://$website";
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, "Could not perform this operation");
    }
  }

}
