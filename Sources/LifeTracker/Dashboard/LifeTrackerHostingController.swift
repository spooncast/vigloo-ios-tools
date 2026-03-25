import SwiftUI
import UIKit
import Combine

internal final class LifeTrackerFloatingViewController: UIViewController {
    private let bottomOffset: CGFloat
    private let buttonSize: CGFloat = 64
    private var cancellables = Set<AnyCancellable>()
    private var highlightWorkItem: DispatchWorkItem?

    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()

    private lazy var floatingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = buttonSize / 2
        button.clipsToBounds = true
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        let emojiLabel = UILabel()
        emojiLabel.text = "🙈"
        emojiLabel.font = .systemFont(ofSize: 24, weight: .bold)

        let stack = UIStackView(arrangedSubviews: [emojiLabel, countLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isUserInteractionEnabled = false

        button.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: button.centerYAnchor),
        ])

        return button
    }()

    init(bottomOffset: CGFloat) {
        self.bottomOffset = bottomOffset
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func loadView() {
        view = PassThroughView()
        view.backgroundColor = .clear
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(floatingButton)
        NSLayoutConstraint.activate([
            floatingButton.widthAnchor.constraint(equalToConstant: buttonSize),
            floatingButton.heightAnchor.constraint(equalToConstant: buttonSize),
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            floatingButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -bottomOffset
            ),
        ])

        LifeTracker.shared.$groups
            .receive(on: DispatchQueue.main)
            .sink { [weak self] groups in
                let count = groups.values.reduce(0) { $0 + $1.totalCount }
                self?.countLabel.text = "\(count)"
                self?.animateHighlight()
            }
            .store(in: &cancellables)
    }

    private func animateHighlight() {
        highlightWorkItem?.cancel()

        UIView.animate(withDuration: 0.15) {
            self.floatingButton.backgroundColor = .systemRed
        }

        let workItem = DispatchWorkItem { [weak self] in
            UIView.animate(withDuration: 0.3) {
                self?.floatingButton.backgroundColor = .systemGreen
            }
        }
        highlightWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: workItem)
    }

    @objc private func buttonTapped() {
        let listView = LifeTrackerListView(tracker: LifeTracker.shared)
        let hostingController = UIHostingController(rootView: listView)
        present(hostingController, animated: true)
    }
}

private final class PassThroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView === self ? nil : hitView
    }
}
