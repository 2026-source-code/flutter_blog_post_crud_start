import 'package:blog/data/post.dart';

int idCounter = 3;

final List<Post> fakePosts = [
  Post(
    id: 1,
    title: "Flutter 시작하기",
    content: "Flutter는 Google에서 만든 크로스 플랫폼 UI 프레임워크입니다.",
    createdAt: "2026-04-20T10:30:00",
    updatedAt: "2026-04-20T10:30:00",
  ),
  Post(
    id: 2,
    title: "Riverpod 상태관리",
    content: "Riverpod는 Provider보다 안전한 상태관리 라이브러리입니다.",
    createdAt: "2026-04-22T14:15:00",
    updatedAt: "2026-04-22T14:15:00",
  ),
  Post(
    id: 3,
    title: "MVVM 패턴",
    content: "View와 ViewModel을 분리해 테스트 가능성을 높입니다.",
    createdAt: "2026-04-25T09:00:00",
    updatedAt: "2026-04-25T09:00:00",
  ),
];
