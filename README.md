### 프로젝트 소개
* 위치 정보를 통해 걷기, 달리기 기록을 측정
<br/>

<kbd><img src = "https://user-images.githubusercontent.com/84059338/224916419-954422ce-72ba-4963-9abc-8ee66e4e412e.gif" width="250"></kbd> &nbsp;&nbsp;&nbsp;
<kbd><img src = "https://user-images.githubusercontent.com/84059338/226114034-3b3a74f3-d2e4-46e5-af23-0c3077ab12fc.gif" width="250"></kbd>

* 시작버튼 클릭시 운동경로 추적. 중지상태 일 때는 타이머와 위치추적 멈춤. 완료버튼 클릭시 CoreData에 저장
* 내 위치에서 15m 벗어났을 때 운동경로 추적 업데이트.
* CMMotionActivityManager를 사용하여 걷기모션, 런닝모션일 때만 운동경로 추적.
* CloudKit을 사용하여 앱을 지우고 다시 설치해도 기록을 유지
* LiveActivities를 사용하여 운동 시작시 LockScreen에 운동정보 출력 (iOS 16.1 이상)
<br/>




### 앱스토어 배포
<img src = "https://user-images.githubusercontent.com/84059338/224919226-2c484db2-f8d6-4caa-9c00-ebfcc3a02c90.png" alt="https://apps.apple.com/kr/app/sanches-run-%EB%8B%AC%EB%A6%AC%EA%B8%B0-%EA%B1%B7%EA%B8%B0/id6446199498" width="120">
<a href="https://apps.apple.com/kr/app/sanches-run-%EB%8B%AC%EB%A6%AC%EA%B8%B0-%EA%B1%B7%EA%B8%B0/id6446199498">Sanches Run: 달리기, 걷기</a>
<br/><br/>
<a href="https://awake-licorice-62e.notion.site/Sanches-Run-4c71644ae04a43cc9f9fb60340cdd28c">개발 일기</a>
<br/><br/>

### 사용기술
* SwiftUI
* Combine
* CoreData
* CloudKit
* CMMotionActivityManager
* ActivityKit
