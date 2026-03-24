import UIKit

final class LifeTrackerListCell: UICollectionViewCell {
    static let identifier = "LifeTrackerListCell"

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.addSubview(self.nameLabel)
        NSLayoutConstraint.activate([
            self.nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.nameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.contentView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.nameLabel.text = nil
    }

    func configure(name: String, count: Int) {
        self.nameLabel.text = "\(name) (\(count))"
    }
}
