# VIGTools

Vigloo iOS 앱에서 사용되는 개발/디버그 유틸리티 모음 Swift Package입니다.

## 제공 라이브러리

### LifeTracker

DEBUG 빌드에서 객체의 생명주기를 실시간으로 추적하는 도구입니다. 화면에 플로팅 버튼으로 현재 살아있는 인스턴스 수를 표시하고, 탭하면 그룹별 상세 목록을 확인할 수 있습니다.

- `#if DEBUG`로 감싸져 있어 릴리즈 빌드에 영향 없음
- 객체가 해제되면 자동으로 추적 해제 (associated object 기반)
- 인스턴스 수 변경 시 플로팅 버튼 색상 피드백 (빨간색 깜빡임)

## 설치

### Swift Package Manager

`Package.swift`에 의존성을 추가합니다:

```swift
dependencies: [
    .package(url: "https://github.com/spooncast/vigloo-ios-tools.git", from: "0.0.2")
]
```

타겟에 `LifeTracker`를 추가합니다:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "LifeTracker", package: "vigloo-ios-tools")
    ]
)
```

또는 Xcode에서 **File > Add Package Dependencies**로 추가할 수 있습니다.

> 최소 지원: iOS 15+

## 사용 방법

### 1. 대시보드 설정

앱 시작 시 `LifeTrackerDashboard.setup()`을 호출합니다:

```swift
import LifeTracker

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options: UIScene.ConnectionOptions) {
        // ...
        LifeTrackerDashboard.setup()
    }
}
```

탭바 등이 있는 경우 `bottomOffset`으로 플로팅 버튼 위치를 조정할 수 있습니다:

```swift
LifeTrackerDashboard.setup(bottomOffset: 100)
```

### 2. 추적할 클래스에 LifeTrackable 채택

```swift
import LifeTracker

class MyViewController: UIViewController, LifeTrackable {
    override func viewDidLoad() {
        super.viewDidLoad()
        trackLifetime()
    }
}
```

그룹명을 커스텀하려면 `lifeConfiguration`을 오버라이드합니다:

```swift
class MyViewController: UIViewController, LifeTrackable {
    static var lifeConfiguration: LifeConfiguration {
        LifeConfiguration(groupName: "ViewControllers")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        trackLifetime()
    }
}
```
