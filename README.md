# iFinance

![Simulator Screen Recording - iPhone 12 Pro - 2022-04-20 at 21 56 17](https://user-images.githubusercontent.com/85341050/164235402-69038090-56db-4f7b-8c2a-be3cf1c88e98.gif)   ![Simulator Screen Recording - iPhone 12 Pro - 2022-04-20 at 21 57 42](https://user-images.githubusercontent.com/85341050/164235719-5140d27a-6a30-4887-8161-989af87bbcc1.gif)   

![Simulator Screen Recording - iPhone 12 Pro - 2022-04-20 at 22 00 18](https://user-images.githubusercontent.com/85341050/164236071-b6a7f1b8-bfd1-499f-b37c-a7c718fc3030.gif) ![Simulator Screen Recording - iPhone 12 Pro - 2022-04-20 at 22 01 05](https://user-images.githubusercontent.com/85341050/164236204-df43e290-c5b9-4af2-9580-f02c1de34c83.gif)   

![Simulator Screen Recording - iPhone 12 Pro - 2022-04-20 at 22 01 54](https://user-images.githubusercontent.com/85341050/164236346-7bc39d57-c0dc-425d-bc9b-1449e5e1223a.gif)   ![Simulator Screen Recording - iPhone 12 Pro - 2022-04-20 at 22 18 08](https://user-images.githubusercontent.com/85341050/164239246-85ed8366-f0de-4ecb-aa02-85d66f44d223.gif)

## 사용한 라이브러리 및 프레임워크
- UIKit 
- Combine

## 이 프로젝트의 이유
- 기존에 작업했던 iFinance를 좀 더 개선된 구조로 Refactoring한 버전으로 만들기 위함
    - MVVM -> MVVM - C 로 Refactoring
    - Combine을 사용해서 구현
- 기존 프로젝트 링크: https://gitlab.com/yokim1/iosappprojects/-/tree/master/iFinance2

## 👥 팀 구성

- 개인 프로젝트

## 🛠️ 사용 기술 및 라이브러리

- Swift, iOS
- Combine
- AutoLayout
- FloatingPanel
- SDWebImage

## 📱 담당한 기능 (iOS)

- Combine을 사용해서 구현
- Chart 라이브러리를 이용해서 가격변동을 표현
- REST API를 이용해서 뉴스, 주식 종목 검색, 특정 종목의 데이터들을 fetching 해서 클라이언트상에서 보여지게 구현
- Firebase realtime database를 사용해서 사용자들이 특정 종목에 관해서 의견을 주고 받을수 있는 게시판을 구현
- 커스텀 뷰 구현 - Custom menu tab-bar
- MVVM-C 적용해서 View, ViewController, ViewModel, Coordinator로 책임을 분리
- 모든 UI와 동작을 Storyboard없이 코드로만 구현
- WWDC 19에 소개됐던 DiffableDatasource를 적용해서 검색 창에 생기는 변화들을 구현
- DispatchGroup을 이용해서 네트워킹시에 발생하는 비동기를 제어
- NotificationCenter와 delegate패턴을 사용해서 view controller 들 사이에 data를 주고 받을수 있게 구현
- Userdefault를 이용해서 사용자가 watch list에 추가한 종목들을 클라이언트에서 저장
- SD web image 라이브러리를 이용해서 image caching을 가능하게 해서 이미지 로딩시 발생할수 있는 앱의 퍼포먼스 저하를 방지
- 사용자가 작성한 글에 양에 따라 셀의 크기가 변할수 있게 auto cell sizing을 적용해서 ux를 향상

## 💡 깨달은 점

- Chart은 편리하게 그래프 UI를 구현할 수 있는 오픈소스이다.
- Floating Panel은 편리하게 위아래로 view를 늘리고 줄일수 있는 UI를 구현할 수 있는 오픈소스이다.
- Firebase realtime databse는 소켓처럼 활용해서 실시간으로 데이터를 실시간으로 반영해준다
- **Extension**은 단순히 코드를 분리하는 역할로 사용할 수도 있지만, 본질적인 의미는 기존 클래스에 새로운 기능을 추가하는 것을 의미한다. 
UIColor에 자주 사용하는 컬러값을 추가하여 사용할 수도 있고, UIView에 커스텀 view를 추가하여 사용할 수도 있다.
