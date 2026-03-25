import SwiftUI

struct LifeTrackerFloatingView: View {
    @ObservedObject var tracker: LifeTracker
    let bottomOffset: CGFloat

    @State private var isShowingDetail = false

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Text("🙈")
                    .font(.system(size: 24, weight: .bold))
                Text("\(totalCount)")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
            }
            .frame(width: 64, height: 64)
            .background(Color.green)
            .clipShape(Circle())
            .position(
                x: geometry.size.width - 48,
                y: geometry.size.height - 48 - geometry.safeAreaInsets.bottom - bottomOffset
            )
            .onTapGesture { isShowingDetail = true }
        }
        .sheet(isPresented: $isShowingDetail) {
            LifeTrackerListView(tracker: tracker)
        }
        .ignoresSafeArea()
    }

    private var totalCount: Int {
        tracker.groups.values.reduce(0) { $0 + $1.totalCount }
    }
}
