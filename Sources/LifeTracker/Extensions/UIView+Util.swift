import UIKit

extension UIView {
    func nearestSheetPresentationController() -> UISheetPresentationController? {
        var responder: UIResponder? = self
        while let next = responder?.next {
            if let vc = next as? UIViewController {
                return vc.sheetPresentationController
            }
            responder = next
        }
        return nil
    }
}
