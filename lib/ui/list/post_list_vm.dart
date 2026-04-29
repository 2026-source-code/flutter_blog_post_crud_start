import 'package:blog/data/post.dart';
import 'package:blog/data/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 창고 데이터 타입 (State)
//    리스트 화면에서는 id, title만 보여주면 되므로 Record로 가볍게 구성
class PostListModel {
  final List<({int id, String title})> posts;

  PostListModel(this.posts);

  // List<Post>로부터 가벼운 (id, title) Record 리스트로 변환
  PostListModel.fromPosts(List<Post> postList)
      : posts = postList.map((p) => (id: p.id, title: p.title)).toList();

  // 포스트 추가 (불변 유지)
  PostListModel addNewPost(Post post) {
    final newPosts = [(id: post.id, title: post.title), ...posts];
    return PostListModel(newPosts);
  }

  // 포스트 삭제 (불변 유지)
  PostListModel removePostById(int id) {
    final filteredPosts = posts.where((post) => post.id != id).toList();
    return PostListModel(filteredPosts);
  }
}

/// 2. 창고 (ViewModel)
/// - Notifier를 상속하여 상태를 관리하고 변경
/// - build(): 초기 상태 설정 (비동기 init 트리거)
/// - notifyXxx(): 상태 변경 메서드
class PostListVM extends Notifier<PostListModel?> {
  @override
  PostListModel? build() {
    // 비동기 초기 데이터 로딩은 fire-and-forget으로 호출
    notifyInit();
    // 처음에는 null(로딩 상태)로 시작
    return null;
  }

  // 초기 데이터 로딩
  Future<void> notifyInit() async {
    final List<Post> list = await PostRepository().findAll();
    state = PostListModel.fromPosts(list);
  }

  // 삭제 트랜잭션 (Navigator.pop은 View가 처리)
  Future<void> notifyDelete(int id) async {
    await PostRepository().deleteById(id);
    final model = state;
    if (model == null) return;
    state = model.removePostById(id);
  }

  // 저장 트랜잭션 (Navigator.pop은 View가 처리)
  Future<void> notifySave(String title, String content) async {
    final model = state;
    state = null; // 저장 시작 → View가 인디케이터 표시
    final Post newPost = await PostRepository().save(title, content);
    if (model == null) return;
    state = model.addNewPost(newPost);
  }
}

// 3. 창고 관리자 (Provider)
final postListProvider = NotifierProvider<PostListVM, PostListModel?>(() {
  return PostListVM();
});
