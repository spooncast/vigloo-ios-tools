import Foundation

public final class LifeEntry {
    public let name: String
    public private(set) var count: Int

    init(name: String) {
        self.name = name
        self.count = 0
    }

    func increment() {
        self.count += 1
    }

    func decrement() {
        self.count -= 1
    }
}
