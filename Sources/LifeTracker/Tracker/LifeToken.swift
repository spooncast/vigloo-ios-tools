import Foundation

final class LifeToken {
    private let configuration: LifeConfiguration

    init(configuration: LifeConfiguration) {
        self.configuration = configuration
    }

    deinit {
        let config = self.configuration
        LifeTracker.scheduleUntrack(config)
    }
}
