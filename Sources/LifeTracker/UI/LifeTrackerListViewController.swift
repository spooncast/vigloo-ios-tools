import UIKit

internal final class LifeTrackerListViewController: UIViewController {
    private struct Item: Hashable {
        let name: String
        let count: Int
    }

    private lazy var collectionView: UICollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.backgroundColor = .clear
        configuration.headerMode = .supplementary

        let listLayout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private var dataSource: UICollectionViewDiffableDataSource<String, Item>?
    private var currentGroups: SimpleOrderedDictionary<String, LifeEntriesGroup>?
    private var hasAppeared = false

    required init?(coder _: NSCoder) { fatalError("init(coder:) is not supported") }

    internal init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .secondarySystemBackground
        self.view.addSubview(self.collectionView)
        self.setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.hasAppeared = true
        self.applySnapshotIfNeeded()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.collectionView.frame = self.view.bounds
    }

    private func setupCollectionView() {
        self.collectionView.register(
            LifeTrackerListCell.self,
            forCellWithReuseIdentifier: LifeTrackerListCell.identifier
        )

        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] cell, _, indexPath in
            guard let self, let dataSource = self.dataSource else { return }

            let sectionID = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            var content = UIListContentConfiguration.groupedHeader()
            content.textProperties.font = .systemFont(ofSize: 20, weight: .bold)
            content.textProperties.color = .white
            content.text = sectionID

            cell.contentConfiguration = content
        }

        let dataSource = UICollectionViewDiffableDataSource<String, Item>(
            collectionView: self.collectionView
        ) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LifeTrackerListCell.identifier,
                for: indexPath
            ) as? LifeTrackerListCell
            else { return UICollectionViewCell() }

            cell.configure(name: item.name, count: item.count)
            return cell
        }

        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
        }

        self.dataSource = dataSource
    }

    private func applySnapshotIfNeeded() {
        guard let groups = self.currentGroups else { return }

        var snapshot = NSDiffableDataSourceSnapshot<String, Item>()
        for (groupName, group) in groups {
            snapshot.appendSections([groupName])
            let items = group.entries.values.map { Item(name: $0.name, count: $0.count) }
            snapshot.appendItems(items.reversed(), toSection: groupName)
        }

        self.dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

internal extension LifeTrackerListViewController {
    func update(with groups: SimpleOrderedDictionary<String, LifeEntriesGroup>) {
        self.currentGroups = groups
        if self.hasAppeared {
            self.applySnapshotIfNeeded()
        }
    }
}
