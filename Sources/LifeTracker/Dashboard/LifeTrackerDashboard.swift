import UIKit

@MainActor
public final class LifeTrackerDashboard {
    private static var instance: LifeTrackerDashboard?

    private var window: LifeTrackerWindow?

    private let topOffset: CGFloat

    private init(topOffset: CGFloat) {
        self.topOffset = topOffset
    }

    private func setupWindow() {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive })
            ?? UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first
        else { return }

        let hostingController = LifeTrackerFloatingViewController(topOffset: self.topOffset)
        let window = LifeTrackerWindow(windowScene: windowScene)
        window.windowLevel = .alert + 1
        window.rootViewController = hostingController
        window.backgroundColor = .clear
        window.isUserInteractionEnabled = true
        window.isHidden = false

        self.window = window
    }
}

public extension LifeTrackerDashboard {
    /// - Parameter topOffset: 플로팅 버튼의 상단 여백 (네비게이션 바 높이 등)
    static func setup(topOffset: CGFloat = 60.0) {
        let dashboard = LifeTrackerDashboard(topOffset: topOffset)
        dashboard.setupWindow()

        LifeTrackerDashboard.instance = dashboard
    }
}
