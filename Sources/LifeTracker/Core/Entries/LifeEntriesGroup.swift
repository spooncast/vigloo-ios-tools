import Foundation

public final class LifeEntriesGroup {
    public let groupName: String
    public private(set) var entries = SimpleOrderedDictionary<String, LifeEntry>()
    public var totalCount: Int { self.entries.values.reduce(0) { $0 + $1.count } }

    init(groupName: String) {
        self.groupName = groupName
    }

    func trackEntry(name: String) {
        if self.entries[name] == nil {
            self.entries[name] = LifeEntry(name: name)
        }
        self.entries[name]?.increment()
    }

    func untrackEntry(name: String) {
        guard let entry = self.entries[name] else { return }

        entry.decrement()

        if entry.count == 0 {
            self.entries.removeValue(forKey: name)
        }
    }
}
