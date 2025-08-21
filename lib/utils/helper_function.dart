import 'package:flutter/material.dart';

showMsg(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

const String deleteMsg = "Are you sure you want to delete";