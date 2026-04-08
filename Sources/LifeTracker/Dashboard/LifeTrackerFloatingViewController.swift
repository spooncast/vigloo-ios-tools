import SwiftUI
import UIKit
import Combine

internal final class LifeTrackerFloatingViewController: UIViewController {
    private let topOffset: CGFloat
    private let buttonSize: CGFloat = 64
    private var cancellables = Set<AnyCancellable>()
    private var highlightWorkItem: DispatchWorkItem?
    private var previousTotalCount = 0
    private var trailingConstraint: NSLayoutConstraint!
    private var topConstraint: NSLayoutConstraint!
    private var panStartTrailing: CGFloat = 0
    private var panStartTop: CGFloat = 0

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

    init(topOffset: CGFloat) {
        self.topOffset = topOffset
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
        trailingConstraint = floatingButton.trailingAnchor.constraint(
            equalTo: view.trailingAnchor, constant: -16
        )
        topConstraint = floatingButton.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topOffset
        )
        NSLayoutConstraint.activate([
            floatingButton.widthAnchor.constraint(equalToConstant: buttonSize),
            floatingButton.heightAnchor.constraint(equalToConstant: buttonSize),
            trailingConstraint,
            topConstraint,
        ])

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        floatingButton.addGestureRecognizer(pan)

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

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        switch gesture.state {
        case .began:
            panStartTrailing = trailingConstraint.constant
            panStartTop = topConstraint.constant

        case .changed:
            let safeArea = view.safeAreaInsets
            let maxTrailing: CGFloat = -safeArea.right
            let minTrailing = -(view.bounds.width - safeArea.left - buttonSize)
            let minTop: CGFloat = 0
            let maxTop = view.bounds.height - safeArea.top - safeArea.bottom - buttonSize

            let newTrailing = min(maxTrailing, max(minTrailing, panStartTrailing + translation.x))
            let newTop = min(maxTop, max(minTop, panStartTop + translation.y))
            trailingConstraint.constant = newTrailing
            topConstraint.constant = newTop

        default:
            break
        }
    }

    @objc private func buttonTapped() {
        let listView = LifeTrackerListView(tracker: LifeTracker.shared)
        let hostingController = UIHostingController(rootView: listView)
        present(hostingController, animated: true)
    }
}
