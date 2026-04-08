import SwiftUI

struct LifeTrackerListView: View {
    @ObservedObject var tracker: LifeTracker

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color(white: 0.6))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 8)

            list
        }
        .background(Color(.darkGray))
    }

    private var list: some View {
        List {
            ForEach(Array(tracker.groups), id: \.0) { groupName, group in
                Section {
                    ForEach(group.entries.values.reversed(), id: \.name) { entry in
                        Text("\(entry.name) (\(entry.count))")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color(.darkGray))
                } header: {
                    Text(groupName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .listStyle(.plain)
        .background(Color(.darkGray))
    }
}
