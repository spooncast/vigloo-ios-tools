import SwiftUI

struct SheetDetentsConfigurator: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            guard let sheet = view.nearestSheetPresentationController() else { return }
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
