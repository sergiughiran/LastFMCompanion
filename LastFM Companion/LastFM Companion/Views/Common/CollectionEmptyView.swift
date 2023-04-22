//
//  CollectionEmptyView.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 05.06.2021.
//

import UIKit

private enum Constants {
    static let spacing: CGFloat = 8.0
    static let titleFont: UIFont = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
    static let descriptionFont: UIFont = UIFont.systemFont(ofSize: 12.0, weight: .light)
    static let imageHeight: CGFloat = 48.0
    static let stackViewWidthMultiplier: CGFloat = 0.75
    static let textColor: UIColor? = UIColor(named: "captionColor")
}

final class CollectionEmptyView: UIView {

    // MARK: - State

    enum Location {
        case library
        case searchScreen
        case album

        var image: UIImage? {
            switch self {
            case .library:
                return UIImage(systemName: "arrow.down.circle")
            case .searchScreen:
                return UIImage(systemName: "magnifyingglass.circle")
            case .album:
                return UIImage(systemName: "music.note.list")
            }
        }

        var title: String {
            switch self {
            case .library:
                return "You have no local albums"
            case .searchScreen:
                return "No results"
            case .album:
                return "No tracks"
            }
        }

        var description: String {
            switch self {
            case .library:
                return "Search for your favourites above and save them for offline use."
            case .searchScreen:
                return "You can search for your favourite artists by typing their name in the box above."
            case .album:
                return "The selected album doesn't contain any tracks. You can select another album from this artist by going back to the previous screen."
            }
        }
    }

    // MARK: - Private Properties

    private let location: Location

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.image = location.image
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.textColor = .white
        label.font = Constants.titleFont
        label.textAlignment = .center
        label.text = location.title

        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()

        label.textColor = Constants.textColor
        label.textAlignment = .center
        label.font = Constants.descriptionFont
        label.numberOfLines = 0
        label.text = location.description

        return label
    }()

    // MARK: - Lifecycle

    init(location: Location) {
        self.location = location

        super.init(frame: .zero)

        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.location = .library

        super.init(coder: coder)

        setupUI()
        setupConstraints()
    }

    // MARK: - Private Methods

    private func setupUI() {
        backgroundColor = .black

        contentStackView.addArrangedSubview(imageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)

        addSubview(contentStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),

            contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.stackViewWidthMultiplier)
        ])
    }
}
