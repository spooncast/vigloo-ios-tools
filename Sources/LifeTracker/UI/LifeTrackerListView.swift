import SwiftUI

struct LifeTrackerListView: View {
    @ObservedObject var tracker: LifeTracker

    var body: some View {
        List {
            ForEach(Array(tracker.groups), id: \.0) { groupName, group in
                Section {
                    ForEach(group.entries.values.reversed(), id: \.name) { entry in
                        Text("\(entry.name) (\(entry.count))")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color(.secondarySystemBackground))
                } header: {
                    Text(groupName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .listStyle(.plain)
        .background(Color(.secondarySystemBackground))
    }
}
