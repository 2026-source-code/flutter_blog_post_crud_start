import 'package:blog/ui/list/components/post_list_body.dart';
import 'package:flutter/material.dart';

class PostListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("게시글목록")),
      body: PostListBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/write");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
