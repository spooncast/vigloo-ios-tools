import UIKit
import LifeTracker

class ViewController: UIViewController, LifeTrackable {
    private var count = 0

    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .monospacedDigitSystemFont(ofSize: 48, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        trackLifetime()

        let minusButton = UIButton(type: .system)
        minusButton.setTitle("−", for: .normal)
        minusButton.titleLabel?.font = .systemFont(ofSize: 32, weight: .bold)
        minusButton.addTarget(self, action: #selector(decrementTapped), for: .touchUpInside)

        let plusButton = UIButton(type: .system)
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = .systemFont(ofSize: 32, weight: .bold)
        plusButton.addTarget(self, action: #selector(incrementTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [minusButton, countLabel, plusButton])
        stack.axis = .horizontal
        stack.spacing = 40
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc private func incrementTapped() {
        count += 1
        countLabel.text = "\(count)"
    }

    @objc private func decrementTapped() {
        count -= 1
        countLabel.text = "\(count)"
    }
}
