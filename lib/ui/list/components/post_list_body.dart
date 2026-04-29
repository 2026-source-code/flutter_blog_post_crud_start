import 'package:blog/ui/detail/post_detail_page.dart';
import 'package:flutter/material.dart';

class PostListBody extends StatelessWidget {
  const PostListBody({super.key});

  @override
  Widget build(BuildContext context) {
    // 그림 더미 데이터 (수업용 placeholder)
    final dummyPosts = [
      (id: 1, title: "제목 1"),
      (id: 2, title: "제목 2"),
      (id: 3, title: "제목 3"),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        itemCount: dummyPosts.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final post = dummyPosts[index];
          return ListTile(
            leading: Text("${post.id}"),
            title: Text(post.title),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailPage(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
