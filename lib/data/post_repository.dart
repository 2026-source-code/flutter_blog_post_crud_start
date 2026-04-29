import 'package:blog/data/db.dart';
import 'package:blog/data/post.dart';

// 실제 서버 통신 대신 Future.delayed + in-memory 가짜 데이터로 동작하는 테스트용 Repository.
// 처음부터 끝까지 Post 객체를 주고받기 때문에 ViewModel에서 Map 파싱이 필요 없다.
class PostRepository {
  static const _delay = Duration(seconds: 2);

  // 전체 조회
  Future<List<Post>> findAll() async {
    await Future.delayed(_delay);
    // 외부에서 내부 리스트를 변경하지 못하도록 방어적 복사
    return [...fakePosts];
  }

  // 단건 조회
  Future<Post> findById(int id) async {
    await Future.delayed(_delay);
    return fakePosts.firstWhere((p) => p.id == id);
  }

  // 저장
  Future<Post> save(String title, String content) async {
    await Future.delayed(_delay);

    // static int를 ++ 해서 새 id 발급
    idCounter++;

    final nowIso = DateTime.now().toIso8601String();
    final newPost = Post(
      id: idCounter,
      title: title,
      content: content,
      createdAt: nowIso,
      updatedAt: nowIso,
    );
    fakePosts.add(newPost);
    return newPost;
  }

  // 삭제
  Future<void> deleteById(int id) async {
    await Future.delayed(_delay);
    fakePosts.removeWhere((p) => p.id == id);
  }
}
