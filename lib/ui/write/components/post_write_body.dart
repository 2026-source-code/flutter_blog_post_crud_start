import 'package:blog/ui/list/post_list_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostWriteBody extends ConsumerWidget {
  final _title = TextEditingController();
  final _content = TextEditingController();

  PostWriteBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 저장 중인지 판단 - model이 null이면 저장 중 (notifySave에서 state=null로 만듦)
    PostListModel? model = ref.watch(postListProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  color: Colors.deepPurple[100],
                  height: 400,
                  width: double.infinity,
                  child: Icon(CupertinoIcons.airplane),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _title,
                ),
                TextFormField(
                  controller: _content,
                ),
              ],
            ),
          ),
          // 저장 중이면 인디케이터, 아니면 버튼 (다른 페이지와 동일한 패턴)
          model == null
              ? CircularProgressIndicator()
              : TextButton(
                  onPressed: () async {
                    await ref
                        .read(postListProvider.notifier)
                        .notifySave(_title.text, _content.text);
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Text("글쓰기"),
                ),
        ],
      ),
    );
  }
}
