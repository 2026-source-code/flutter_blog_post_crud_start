import 'package:blog/ui_v2/post_list_vm_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// =====================================================================
// V2: AsyncNotifier 패턴을 사용하는 화면
//
//   v1과의 핵심 차이:
//   - v1: if(model == null) CircularProgressIndicator() else ListView(...)
//         → 로딩과 '데이터 없음'을 구분 못 하고, 에러 분기는 아예 없음
//   - v2: asyncModel.when(loading:, error:, data:)
//         → 3가지 상태(loading/error/data)를 컴파일 타임에 강제
//         → 에러가 나도 앱이 죽지 않고 에러 화면이 표시됨
// =====================================================================

class PostListPageV2 extends ConsumerWidget {
  const PostListPageV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AsyncValue<PostListModelV2> — 안에 loading/error/data 셋 중 하나가 들어있다
    final asyncModel = ref.watch(postListProviderV2);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Post List V2 (AsyncNotifier)"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "새로고침",
            onPressed: () =>
                ref.read(postListProviderV2.notifier).notifyRefresh(),
          ),
        ],
      ),

      // 핵심! .when()으로 3가지 상태를 강제로 처리
      body: asyncModel.when(
        // ① 로딩 중
        loading: () => const Center(child: CircularProgressIndicator()),

        // ② 에러 발생 (build()에서 throw 되거나, guard 안에서 실패하면 여기로)
        error: (e, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 56, color: Colors.red),
              const SizedBox(height: 12),
              Text("에러: $e"),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref
                    .read(postListProviderV2.notifier)
                    .notifyRefresh(),
                child: const Text("다시 시도"),
              ),
            ],
          ),
        ),

        // ③ 데이터 도착 — model은 non-null이 보장됨
        data: (model) {
          if (model.posts.isEmpty) {
            return const Center(child: Text("게시글이 없습니다."));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.separated(
              itemCount: model.posts.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final post = model.posts[index];
                return ListTile(
                  leading: Text("${post.id}"),
                  title: Text(post.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => ref
                        .read(postListProviderV2.notifier)
                        .notifyDelete(post.id),
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showWriteDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  // 간단한 글쓰기 다이얼로그 (mutation 데모용)
  void _showWriteDialog(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("글쓰기"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: "제목"),
            ),
            TextField(
              controller: contentCtrl,
              decoration: const InputDecoration(labelText: "내용"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(postListProviderV2.notifier)
                  .notifySave(titleCtrl.text, contentCtrl.text);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text("저장"),
          ),
        ],
      ),
    );
  }
}
