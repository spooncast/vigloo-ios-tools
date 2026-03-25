# CLAUDE.md

이 파일은 Claude Code (claude.ai/code)가 이 저장소의 코드를 다룰 때 참고하는 가이드입니다.

## 개요

VIGTools는 iOS 앱용 디버그 유틸리티를 담은 Swift Package(SPM)입니다. 패키지명은 `VIGTools`이며, 각 도구가 별도의 라이브러리 타겟으로 구성되는 멀티 프로덕트 구조입니다.

## 빌드

```bash
swift build
swift test   # 아직 테스트 없음
```

최소 배포 타겟: iOS 15. Swift tools version: 5.9.

## 아키텍처

### LifeTracker — 현재 유일한 프로덕트

`LifeTrackable`을 채택한 클래스의 살아있는 인스턴스 수를 플로팅 오버레이로 보여주는 DEBUG 전용 객체 생명주기 추적기입니다.

**핵심 흐름:**
1. 클래스가 `LifeTrackable`을 채택하고 `trackLifetime()`을 호출 (보통 `init`에서)
2. `trackLifetime()`이 `objc_setAssociatedObject`를 통해 `LifeToken`을 부착 — 호스트 객체가 해제되면 토큰의 `deinit`에서 `untrack` 호출
3. `LifeTracker`(싱글톤)가 concurrent 큐에서 barrier write로 엔트리 그룹을 관리하고, `onUpdate` 클로저를 통해 메인 스레드에서 UI에 알림
4. `LifeTrackerDashboard.setup()`이 터치 패스스루 `LifeTrackerWindow`(`.alert + 1` 레벨)를 생성하여 전체 생존 카운트를 플로팅 버튼으로 표시; 탭하면 그룹별 상세 시트가 열림

**주요 설계 결정:**
- 모든 추적 코드는 `#if DEBUG`로 감싸져 있어 릴리즈 빌드에서 오버헤드 없음
- `SimpleOrderedDictionary`로 삽입 순서를 유지하여 안정적인 UI 표시
- `LifeTrackerWindow.hitTest`가 빈 영역에서 `nil`을 반환하여 터치가 앱으로 통과
- Actor가 아닌 `DispatchQueue`의 concurrent read / barrier write로 스레드 안전성 확보
