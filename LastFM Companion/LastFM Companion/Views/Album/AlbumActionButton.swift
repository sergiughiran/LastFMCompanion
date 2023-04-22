//
//  AlbumActionButton.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 15.06.2021.
//

import UIKit

private enum Constants {
    static let cornerRadius: CGFloat = 8.0
    static let inset: CGFloat = 4.0
    static let font: UIFont = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
    static let animationDuration: TimeInterval = 0.33
}

final class AlbumActionButton: UIButton {

    // MARK: - Type

    enum `Type`: Equatable {
        case info
        case save
        case remove

        var icon: UIImage? {
            switch self {
            case .info:
                return UIImage(systemName: "info.circle.fill")
            case .save:
                return UIImage(systemName: "arrow.down.circle")
            case .remove:
                return UIImage(systemName: "xmark.circle.fill")
            }
        }

        var title: String {
            switch self {
            case .info:
                return "Info"
            case .save:
                return "Save"
            case .remove:
                return "Remove"
            }
        }

        var backgroundColor: UIColor? {
            switch self {
            case .info, .save:
                return UIColor(named: "accentColor")
            case .remove:
                return UIColor.white
            }
        }

        var tintColor: UIColor? {
            switch self {
            case .info, .save:
                return .white
            case .remove:
                return UIColor(named: "accentColor")
            }
        }
    }

    // MARK: - Private Properties

    var type: `Type` = .save

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - Public Methods

    func setup(with type: Type) {
        self.type = type

        backgroundColor = type.backgroundColor

        setTitleColor(type.tintColor, for: .normal)
        setTitle(type.title, for: .normal)
        titleLabel?.font = Constants.font

        setImage(type.icon, for: .normal)
        tintColor = type.tintColor
    }

    func updateSaved(isSaved: Bool) {
        guard type != .info else { return }

        let type: Type = isSaved ? .remove : .save

        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.setup(with: type)
        }
    }

    // MARK: - Private Methods

    private func setupUI() {
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true

        imageEdgeInsets = UIEdgeInsets(top: 0, left: -Constants.inset, bottom: 0, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: Constants.inset, bottom: 0, right: 0)
    }
}
