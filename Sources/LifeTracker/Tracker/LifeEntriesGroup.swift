import Foundation

struct LifeEntriesGroup: Sendable {
    let groupName: String
    private(set) var entries = SimpleOrderedDictionary<String, LifeEntry>()
    var totalCount: Int { self.entries.values.reduce(0) { $0 + $1.count } }

    init(groupName: String) {
        self.groupName = groupName
    }

    mutating func trackEntry(name: String) {
        var entry = self.entries[name] ?? LifeEntry(name: name)
        entry.increment()
        self.entries[name] = entry
    }

    mutating func untrackEntry(name: String) {
        guard var entry = self.entries[name] else { return }

        entry.decrement()

        if entry.count == 0 {
            self.entries.removeValue(forKey: name)
        } else {
            self.entries[name] = entry
        }
    }
}
