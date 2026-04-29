import 'package:blog/core/utils.dart';
import 'package:blog/data/post.dart';
import 'package:blog/data/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 창고 데이터 (State)
//    Post를 그대로 노출해도 되지만, 화면 표시용으로 createdAt/updatedAt을
//    포맷팅하기 위해 별도의 Model을 둔다 (View Model 변환 계층).
class PostDetailModel {
  final int id;
  final String title;
  final String content;
  final String createdAt;
  final String updatedAt;

  // Post → PostDetailModel 변환 (날짜 포맷팅 포함)
  PostDetailModel.fromPost(Post p)
      : id = p.id,
        title = p.title,
        content = p.content,
        createdAt = formatDate(p.createdAt),
        updatedAt = formatDate(p.updatedAt);
}

/// 2. 창고 (ViewModel)
/// - Riverpod 3.0부터는 family/autoDispose 전용 Notifier 클래스가 사라짐
/// - 그냥 Notifier<T>를 상속하고, family 인자는 생성자로 받아 필드로 보관
/// - autoDispose는 Provider 선언에만 붙임
class PostDetailVM extends Notifier<PostDetailModel?> {
  // family 인자(id)를 생성자로 받음
  PostDetailVM(this.id);
  final int id;

  @override
  PostDetailModel? build() {
    // 비동기 초기 데이터 로딩은 fire-and-forget으로 호출
    notifyInit();
    // 처음에는 null(로딩 상태)
    return null;
  }

  Future<void> notifyInit() async {
    final Post post = await PostRepository().findById(id);
    state = PostDetailModel.fromPost(post);
  }
}

// 3. 창고 관리자 (Provider) - autoDispose + family
final postDetailProvider = NotifierProvider.autoDispose
    .family<PostDetailVM, PostDetailModel?, int>((int id) {
  return PostDetailVM(id);
});
