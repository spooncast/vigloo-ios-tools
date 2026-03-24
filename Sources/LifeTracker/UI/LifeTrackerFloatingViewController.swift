import UIKit

internal final class LifeTrackerFloatingViewController: UIViewController {
    private var latestGroups = SimpleOrderedDictionary<String, LifeEntriesGroup>()
    private weak var listViewController: LifeTrackerListViewController?

    private let bottomOffset: CGFloat

    private let containerView = UIView()

    private let floatingView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = 32.0
        view.clipsToBounds = true
        return view
    }()

    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "🙈"
        label.textAlignment = .center
        return label
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.text = "0"
        label.textAlignment = .center
        return label
    }()

    private lazy var detailButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(self.showDetail), for: .touchUpInside)
        return button
    }()

    required init?(coder _: NSCoder) { fatalError("init(coder:) is not supported") }

    internal init(bottomOffset: CGFloat) {
        self.bottomOffset = bottomOffset
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .clear
        self.view.isOpaque = false

        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.floatingView)
        self.floatingView.addSubview(self.emojiLabel)
        self.floatingView.addSubview(self.countLabel)
        self.containerView.addSubview(self.detailButton)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.layout()
    }

    private func layout() {
        let size: CGFloat = 64.0
        let safeBottom = self.view.safeAreaInsets.bottom

        self.containerView.frame = CGRect(
            x: self.view.bounds.width - size - 16.0,
            y: self.view.bounds.height - size - safeBottom - self.bottomOffset,
            width: size,
            height: size
        )

        self.floatingView.frame = self.containerView.bounds
        self.detailButton.frame = self.containerView.bounds

        let emojiHeight: CGFloat = 28.0
        let countHeight: CGFloat = 18.0
        let totalHeight = emojiHeight + countHeight
        let topY = (size - totalHeight) / 2.0

        self.emojiLabel.frame = CGRect(x: 0, y: topY, width: size, height: emojiHeight)
        self.countLabel.frame = CGRect(x: 0, y: topY + emojiHeight, width: size, height: countHeight)
    }

    @objc private func showDetail() {
        let listViewController = LifeTrackerListViewController()
        self.listViewController = listViewController
        listViewController.update(with: self.latestGroups)

        listViewController.modalPresentationStyle = .pageSheet

        if let sheet = listViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
        }

        self.present(listViewController, animated: true)
    }
}

internal extension LifeTrackerFloatingViewController {
    func update(with groups: SimpleOrderedDictionary<String, LifeEntriesGroup>) {
        self.latestGroups = groups
        self.listViewController?.update(with: groups)

        let totalCount = groups.values.reduce(0) { $0 + $1.totalCount }
        self.countLabel.text = "\(totalCount)"
    }
}
