import Foundation
import Combine

actor LifeTrackerStore {
    var groups = SimpleOrderedDictionary<String, LifeEntriesGroup>()

    func track(configuration: LifeConfiguration) -> SimpleOrderedDictionary<String, LifeEntriesGroup> {
        let groupName = configuration.groupName
        let name = configuration.name

        var group = self.groups[groupName] ?? LifeEntriesGroup(groupName: groupName)
        group.trackEntry(name: name)
        self.groups[groupName] = group

        return self.groups
    }

    func untrack(configuration: LifeConfiguration) -> SimpleOrderedDictionary<String, LifeEntriesGroup> {
        let groupName = configuration.groupName
        let name = configuration.name

        guard var group = self.groups[groupName] else { return self.groups }

        group.untrackEntry(name: name)

        if group.entries.isEmpty {
            self.groups.removeValue(forKey: groupName)
        } else {
            self.groups[groupName] = group
        }

        return self.groups
    }
}

@MainActor
public final class LifeTracker: ObservableObject {
    public static let shared = LifeTracker()

    @Published public private(set) var groups = SimpleOrderedDictionary<String, LifeEntriesGroup>()

    internal let store = LifeTrackerStore()

    private init() {}

    internal func track(_ object: AnyObject, configuration: LifeConfiguration) {
        Task {
            let snapshot = await self.store.track(configuration: configuration)
            self.groups = snapshot
        }
    }

    internal func untrack(_ configuration: LifeConfiguration) {
        Task {
            let snapshot = await self.store.untrack(configuration: configuration)
            self.groups = snapshot
        }
    }

    nonisolated static func scheduleTrack(_ object: AnyObject, configuration: LifeConfiguration) {
        Task { @MainActor in
            LifeTracker.shared.track(object, configuration: configuration)
        }
    }

    nonisolated static func scheduleUntrack(_ configuration: LifeConfiguration) {
        Task { @MainActor in
            LifeTracker.shared.untrack(configuration)
        }
    }
}
