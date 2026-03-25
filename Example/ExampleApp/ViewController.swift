import UIKit
import LifeTracker

class ViewController: UIViewController, LifeTrackable {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        trackLifetime()
    }
}
