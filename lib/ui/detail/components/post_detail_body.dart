import 'package:blog/ui/detail/post_detail_vm.dart';
import 'package:blog/ui/list/post_list_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PostDetailBody extends ConsumerWidget {
  final int id;
  const PostDetailBody(this.id, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PostDetailModel? model = ref.watch(postDetailProvider(id));

    if (model == null) {
      return CircularProgressIndicator();
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                child: Icon(CupertinoIcons.trash_fill),
                onPressed: () async {
                  // 1. VM에 삭제 요청 (삭제 끝날 때까지 대기)
                  await ref
                      .read(postListProvider.notifier)
                      .notifyDelete(model.id);
                  // 2. 화면 전환은 View가 직접 처리 (mContext 안 씀!)
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: 10),
            Text("id : ${model.id}", style: TextStyle(fontSize: 20)),
            Text("title : ${model.title}"),
            Text("content : ${model.content}"),
            Text("createdAt : ${model.createdAt}"),
            Text("updatedAt : ${model.updatedAt}"),
          ],
        ),
      );
    }
  }
}
