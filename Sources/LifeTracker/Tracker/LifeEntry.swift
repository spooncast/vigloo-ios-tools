import Foundation

struct LifeEntry: Sendable {
    let name: String
    private(set) var count: Int

    init(name: String) {
        self.name = name
        self.count = 0
    }

    mutating func increment() {
        self.count += 1
    }

    mutating func decrement() {
        self.count -= 1
    }
}
