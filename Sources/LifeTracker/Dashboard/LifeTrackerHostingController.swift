import SwiftUI
import UIKit

internal final class LifeTrackerHostingController: UIHostingController<LifeTrackerFloatingView> {
    init(bottomOffset: CGFloat) {
        let rootView = LifeTrackerFloatingView(
            tracker: LifeTracker.shared,
            bottomOffset: bottomOffset
        )
        super.init(rootView: rootView)
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
}
