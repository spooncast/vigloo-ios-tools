import Foundation

final class LifeToken {
    private let configuration: LifeConfiguration

    init(configuration: LifeConfiguration) {
        self.configuration = configuration
    }

    deinit {
        LifeTracker.shared.untrack(self.configuration)
    }
}
