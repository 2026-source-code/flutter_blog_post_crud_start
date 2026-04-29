import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostDetailBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {},
              child: const Icon(CupertinoIcons.trash_fill),
            ),
          ),
          const SizedBox(height: 10),
          const Text("id : 1", style: TextStyle(fontSize: 20)),
          const Text("title : 제목"),
          const Text("content : 내용"),
          const Text("createdAt : 2026.04.29"),
          const Text("updatedAt : 2026.04.29"),
        ],
      ),
    );
  }
}
