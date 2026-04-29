import 'package:blog/core/theme.dart';
import 'package:blog/ui/list/post_list_page.dart';
import 'package:blog/ui/write/post_write_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      initialRoute: "/",
      routes: {
        "/": (context) => PostListPage(),
        "/write": (context) => PostWritePage(),
      },
    );
  }
}
