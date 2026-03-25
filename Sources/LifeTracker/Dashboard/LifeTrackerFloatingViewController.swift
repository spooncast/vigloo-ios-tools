import SwiftUI
import UIKit
import Combine

internal final class LifeTrackerFloatingViewController: UIViewController {
    private let bottomOffset: CGFloat
    private let buttonSize: CGFloat = 64
    private var cancellables = Set<AnyCancellable>()
    private var highlightWorkItem: DispatchWorkItem?
    private var previousTotalCount = 0

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
                guard let self else { return }
                let newCount = groups.values.reduce(0) { $0 + $1.totalCount }
                let diff = newCount - self.previousTotalCount
                self.previousTotalCount = newCount
                self.countLabel.text = "\(newCount)"
                if diff != 0 {
                    self.animateHighlight(increased: diff > 0)
                }
            }
            .store(in: &cancellables)
    }

    private func animateHighlight(increased: Bool) {
        highlightWorkItem?.cancel()

        let highlightColor: UIColor = increased ? .systemRed : .systemBlue

        UIView.animate(withDuration: 0.15) {
            self.floatingButton.backgroundColor = highlightColor
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
