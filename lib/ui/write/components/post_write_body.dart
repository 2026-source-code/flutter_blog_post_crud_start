import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostWriteBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: 10),
                TextFormField(),
                TextFormField(),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text("글쓰기"),
          ),
        ],
      ),
    );
  }
}
