import Foundation

public final class LifeTracker {
    public static let shared = LifeTracker()

    public var onUpdate: ((SimpleOrderedDictionary<String, LifeEntriesGroup>) -> Void)?
    private var groups = SimpleOrderedDictionary<String, LifeEntriesGroup>()

    private let queue = DispatchQueue(
        label: "com.lifetracker.queue",
        attributes: .concurrent
    )

    private init() {}

    internal func track(_: AnyObject, configuration: LifeConfiguration) {
        self.queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }

            let groupName = configuration.groupName
            let name = configuration.name

            if self.groups[groupName] == nil {
                self.groups[groupName] = LifeEntriesGroup(groupName: groupName)
            }

            self.groups[groupName]?.trackEntry(name: name)
            self.notifyUpdate()
        }
    }

    internal func untrack(_ configuration: LifeConfiguration) {
        self.queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }

            let groupName = configuration.groupName
            let name = configuration.name

            guard let group = self.groups[groupName] else { return }

            group.untrackEntry(name: name)
            if group.entries.isEmpty {
                self.groups.removeValue(forKey: groupName)
            }

            self.notifyUpdate()
        }
    }

    private func notifyUpdate() {
        let snapshot = self.groups
        DispatchQueue.main.async { [weak self] in
            self?.onUpdate?(snapshot)
        }
    }
}
