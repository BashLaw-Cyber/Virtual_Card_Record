import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vcard/models/contact_model.dart';
import 'package:vcard/pages/home_page.dart';
import 'package:vcard/providers/contact_provider.dart';
import 'package:vcard/utils/constants.dart';
import 'package:vcard/utils/helper_function.dart';

class FormPage extends StatefulWidget {
  static const String routeName = "form";
  final ContactModel contactModel;

  const FormPage({super.key, required this.contactModel});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final companyController = TextEditingController();
  final websiteController = TextEditingController();
  final designationController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.contactModel.name;
    mobileController.text = widget.contactModel.mobile;
    emailController.text = widget.contactModel.email;
    addressController.text = widget.contactModel.address;
    companyController.text = widget.contactModel.company;
    websiteController.text = widget.contactModel.website;
    designationController.text = widget.contactModel.designation;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: saveContact, icon: Icon(Icons.save))],
        title: Text("Form Page"),
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                controller: nameController,
                decoration: InputDecoration(labelText: "Contact Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return ContactProperties.emptyFieldMsg;
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: mobileController,
                decoration: InputDecoration(labelText: "Mobile No."),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return ContactProperties.emptyFieldMsg;
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return ContactProperties.emptyFieldMsg;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: companyController,
                decoration: InputDecoration(labelText: "Company Name"),
                validator: (value) {
                  return null;
                },
              ),
              TextFormField(
                controller: designationController,
                decoration: InputDecoration(labelText: "Designation"),
                validator: (value) {
                  return null;
                },
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: "Address"),
                validator: (value) {
                  return null;
                },
              ),
              TextFormField(
                controller: websiteController,
                decoration: InputDecoration(labelText: "Website"),
                validator: (value) {
                  return null;
                },
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    addressController.dispose();
    companyController.dispose();
    websiteController.dispose();
    designationController.dispose();
    super.dispose();
  }

  void saveContact() async {
    if (_formKey.currentState!.validate()) {
      widget.contactModel.name = nameController.text;
      widget.contactModel.mobile = mobileController.text;
      widget.contactModel.email = emailController.text;
      widget.contactModel.address = addressController.text;
      widget.contactModel.designation = designationController.text;
      widget.contactModel.company = companyController.text;
      widget.contactModel.website = websiteController.text;
      Provider.of<ContactProvider>(context, listen: false)
          .insertContact(widget.contactModel)
          .then((value) {
        if (value > 0) {
          showMsg(context, "Saved");
          context.goNamed(HomePage.routeName);
        }
      }).catchError((onError) {
        print("Here is the error: $onError fullstop");
        showMsg(context, "Failed to save");
      });
    }
  }
}
