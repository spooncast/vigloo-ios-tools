import SwiftUI

struct LifeTrackerFloatingView: View {
    @ObservedObject var tracker: LifeTracker
    let bottomOffset: CGFloat

    @State private var isShowingDetail = false
    @State private var isHighlighted = false
    @State private var highlightTask: Task<Void, Never>?

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
            .background(isHighlighted ? Color.red : Color.green)
            .clipShape(Circle())
            .position(
                x: geometry.size.width - 48,
                y: geometry.size.height - 48 - geometry.safeAreaInsets.bottom - bottomOffset
            )
            .onTapGesture { isShowingDetail = true }
        }
        .sheet(isPresented: $isShowingDetail) {
            LifeTrackerListView(tracker: tracker)
                .background(SheetDetentsConfigurator())
        }
        .ignoresSafeArea()
        .onChange(of: totalCount) { _ in
            highlightTask?.cancel()
            withAnimation(.easeIn(duration: 0.15)) {
                isHighlighted = true
            }
            highlightTask = Task {
                try? await Task.sleep(nanoseconds: 400_000_000)
                guard !Task.isCancelled else { return }
                withAnimation(.easeOut(duration: 0.3)) {
                    isHighlighted = false
                }
            }
        }
    }

    private var totalCount: Int {
        tracker.groups.values.reduce(0) { $0 + $1.totalCount }
    }
}
