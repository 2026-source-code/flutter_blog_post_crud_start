import 'package:blog/data/post.dart';
import 'package:blog/data/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// =====================================================================
// V2: AsyncNotifier 버전
//   v1과 비교하면 차이점은 단 두 가지
//   1) Notifier<Model?>  →  AsyncNotifier<Model>   (모델 자체는 non-null)
//   2) build()가 async  →  return Future<Model>    (로딩/에러 자동 표현)
//
//   View 쪽에서는 if(model == null) 분기 대신
//   asyncModel.when(loading: ..., error: ..., data: ...) 를 강제로 쓴다.
//   에러 상태가 타입 시스템에 들어왔다는 게 핵심!
// =====================================================================

// 1. 창고 데이터 타입 (State)
class PostListModelV2 {
  final List<({int id, String title})> posts;

  PostListModelV2(this.posts);

  // List<Post>로부터 가벼운 (id, title) Record 리스트로 변환
  PostListModelV2.fromPosts(List<Post> postList)
      : posts = postList.map((p) => (id: p.id, title: p.title)).toList();

  // 포스트 추가 (불변 유지)
  PostListModelV2 addNewPost(Post post) {
    return PostListModelV2([(id: post.id, title: post.title), ...posts]);
  }

  // 포스트 삭제 (불변 유지)
  PostListModelV2 removePostById(int id) {
    final filtered = posts.where((p) => p.id != id).toList();
    return PostListModelV2(filtered);
  }
}

/// 2. 창고 (ViewModel - AsyncNotifier)
/// - build()가 async → 자동으로 AsyncValue<Model>로 감싸짐
///   * 진행 중   → AsyncLoading
///   * 성공      → AsyncData(model)
///   * 에러 발생 → AsyncError(error, stackTrace)
/// - state.value : 현재 데이터(없으면 null)
/// - state = AsyncData(...)        : 새 데이터로 교체
/// - state = const AsyncLoading() : 로딩 표시
/// - AsyncValue.guard(...)         : try/catch 자동
class PostListVMV2 extends AsyncNotifier<PostListModelV2> {
  // build()는 AsyncNotifier의 lifecycle 메서드라 이름은 그대로 두지만,
  // 실제 fetch 로직은 notifyInit()에 모아 v1과 컨벤션을 맞춘다.
  @override
  Future<PostListModelV2> build() => notifyInit();

  // 초기 데이터 로딩 (build()에서 한 번, refresh에서 한 번 재사용)
  Future<PostListModelV2> notifyInit() async {
    // 여기서 throw 하면 → 자동으로 AsyncError로 잡힘
    final List<Post> list = await PostRepository().findAll();
    return PostListModelV2.fromPosts(list);
  }

  // 삭제
  Future<void> notifyDelete(int id) async {
    final prev = state.value;
    if (prev == null) return;

    // AsyncValue.guard: 내부에서 throw 되면 AsyncError, 성공하면 AsyncData
    state = await AsyncValue.guard(() async {
      await PostRepository().deleteById(id);
      return prev.removePostById(id);
    });
  }

  // 저장
  Future<void> notifySave(String title, String content) async {
    final prev = state.value;
    if (prev == null) return;

    state = await AsyncValue.guard(() async {
      final Post newPost = await PostRepository().save(title, content);
      return prev.addNewPost(newPost);
    });
  }

  // 새로고침 (로딩 표시 → notifyInit 재사용)
  Future<void> notifyRefresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(notifyInit);
  }
}

// 3. 창고 관리자 (Provider)
final postListProviderV2 =
    AsyncNotifierProvider<PostListVMV2, PostListModelV2>(() {
  return PostListVMV2();
});
