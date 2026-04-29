import 'package:blog/ui/detail/components/post_detail_body.dart';
import 'package:flutter/material.dart';

class PostDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PostDetailBody(),
    );
  }
}
