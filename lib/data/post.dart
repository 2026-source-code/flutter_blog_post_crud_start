// 도메인 모델 클래스 (DTO 역할도 겸함)
// - Map<String, dynamic> 대신 타입 안전한 객체로 데이터 주고받기 위함
// - 진짜 서버 통신으로 바꿀 때는 Post.fromJson(Map) 팩토리만 추가하면 됨
class Post {
  final int id;
  final String title;
  final String content;
  final String createdAt;
  final String updatedAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
}
