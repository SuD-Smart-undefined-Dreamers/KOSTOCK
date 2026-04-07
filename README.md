# KOSTOCK

Flutter 기반의 주식 정보·거래 시뮬레이터 앱입니다. 이메일/구글/익명 로그인, 뉴스·주가 조회, 관심종목 관리, 간단한 주문 화면, 자산 탭, 그리고 외부 챗봇 연동을 제공합니다. UI는 다크 테마와 붉은 포인트 컬러를 사용합니다.

## 주요 기능
- **인증**: Firebase Auth 기반 이메일/비밀번호, Google, 익명 로그인 지원.
- **홈**: 추천 종목 카드, 검색창, 요약 뉴스/관심종목/챗봇 섹션으로 이동.
- **뉴스**: Alpha Vantage `NEWS_SENTIMENT` API로 AAPL 뉴스 리스트 표시, 관심종목 즐겨찾기 연동.
- **관심종목**: Provider 상태 관리로 뉴스/관심 목록 토글 및 저장(메모리).
- **주식 현재가**: Alpha Vantage `TIME_SERIES_INTRADAY`로 AAPL, MSFT 시세 조회 및 새로고침.
- **주문/자산**: 주문·자동감시 입력 폼, 자산 요약·보유 종목 예시, 계정 삭제/로그아웃.
- **챗봇**: 외부 엔드포인트(`https://chatbot-oupmu.run.goorm.site/question`) POST 호출로 Q&A.
- **약관**: 간단한 이용약관 화면 제공.

## 기술 스택
- Flutter
- Firebase Core/Auth
- Google Sign-In
- Provider (상태 관리)
- HTTP (REST API 호출)
- Alpha Vantage API (주가/뉴스)

## 프로젝트 구조 (주요 경로)
- `lib/main.dart` : Firebase 초기화, 전역 라우팅, Provider 주입.
- `lib/LoginMenu/` : `login_page.dart`, `signup_page.dart` (인증 흐름), `terms_page.dart`.
- `lib/main_page.dart` : 하단 내비게이션 및 탭 구성(홈/뉴스/관심/주문/MY 자산/현재가).
- `lib/MainMenu/` :
  - `home_page.dart` : 홈 피드, 뉴스/관심/챗봇 섹션.
  - `news_page.dart` : 뉴스 목록, 즐겨찾기.
  - `interest_page.dart`, `interest_provider.dart` : 관심종목 상태 관리.
  - `current_stock_page.dart` : 실시간 시세 뷰.
  - `stock_order_page.dart` : 주문/자동감시 UI.
  - `my_assets_page.dart` : 자산·마이페이지 탭, 계정 삭제.
- `lib/BotSetting/xs_chatbot.dart` : 챗봇 화면.

## 사전 준비
1. **Flutter SDK** 설치 및 `flutter doctor` 정상 상태 확인.
2. **Firebase 프로젝트** 생성 후 플랫폼별 설정 파일 배치
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`
   - macOS: `macos/Runner/GoogleService-Info.plist`
3. **Alpha Vantage API Key** 발급(무료) 후 코드 내 키 교체:
   - `lib/MainMenu/home_page.dart` (`apiKey`)
   - `lib/MainMenu/current_stock_page.dart` (`apiKey`)
   - `lib/MainMenu/news_page.dart` (`apiKey`)
4. (선택) 챗봇 엔드포인트가 다를 경우 `lib/BotSetting/xs_chatbot.dart`의 URL 수정.

## 실행 방법
```bash
flutter pub get
flutter run   # 에뮬레이터 또는 실기기 연결 후
```

## 동작 개요
- **앱 진입** → `LoginPage`에서 로그인/회원가입/익명 로그인.
- **메인 화면** → 하단 바 탭으로 홈/뉴스/관심/주문/MY 자산/현재가 이동.
- **데이터 호출** → Alpha Vantage REST API를 `http` 패키지로 호출, 간단 파싱 후 표시.
- **상태 관리** → 관심종목 즐겨찾기는 `Provider`로 메모리 내 관리(스토리지 미사용).

## 다운로드
- 최신 릴리스: [v0.0.1-alpha](https://github.com/Seungpyo1007/KOSTOCK/releases/tag/v0.0.1-alpha)
- 모든 릴리스 보기: [Releases](https://github.com/Seungpyo1007/KOSTOCK/releases)

## 빌드/배포 참고
- `pubspec.yaml`에 아이콘 경로(`assets/icon/icon_img.png`)가 설정되어 있으며 `flutter_launcher_icons`로 아이콘 생성 가능.
- 릴리스 빌드시 각 플랫폼별 Firebase, 서명/프로비저닝 설정을 완료하세요.

## 라이선스
MIT License. 자세한 내용은 [LICENSE](LICENSE) 파일을 참고하세요.

