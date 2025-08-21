import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vcard/models/contact_model.dart';
import 'package:vcard/pages/contact_detail_page.dart';
import 'package:vcard/pages/form_page.dart';
import 'package:vcard/pages/scan_page.dart';
import 'package:vcard/pages/home_page.dart';
import 'package:vcard/providers/contact_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ContactProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }

  final _router = GoRouter(initialLocation: "/", routes: [
    GoRoute(
        name: HomePage.routeName,
        path: '/',
        builder: (context, state) => HomePage(),
        routes: [
          GoRoute(
            path: ContactDetailPage.routeName,
            name: ContactDetailPage.routeName,
            builder: (context, state) =>
                ContactDetailPage(id: state.extra! as int),
          ),
          GoRoute(
              path: ScanPage.route,
              name: ScanPage.route,
              builder: (context, state) => ScanPage(),
              routes: [
                GoRoute(
                  path: FormPage.routeName,
                  name: FormPage.routeName,
                  builder: (context, state) => FormPage(
                    contactModel: state.extra as ContactModel,
                  ),
                )
              ])
        ])
  ]);
}
