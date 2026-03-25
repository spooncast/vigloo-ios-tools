import UIKit

@MainActor
public final class LifeTrackerDashboard {
    private static var instance: LifeTrackerDashboard?

    private var window: LifeTrackerWindow?

    private let bottomOffset: CGFloat

    private init(bottomOffset: CGFloat) {
        self.bottomOffset = bottomOffset
    }

    private func setupWindow() {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive })
            ?? UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first
        else { return }

        let hostingController = LifeTrackerHostingController(bottomOffset: self.bottomOffset)
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
    /// - Parameter bottomOffset: 플로팅 버튼의 하단 여백 (탭바 높이 등)
    static func setup(bottomOffset: CGFloat = 60.0) {
        let dashboard = LifeTrackerDashboard(bottomOffset: bottomOffset)
        dashboard.setupWindow()

        LifeTrackerDashboard.instance = dashboard
    }
}
