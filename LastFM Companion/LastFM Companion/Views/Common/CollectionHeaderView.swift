//
//  CollectionHeaderView.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 15.06.2021.
//

import UIKit

private enum Constants {
    static let titleFont: UIFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
    static let horizontalPadding: CGFloat = 24.0
    static let verticalPadding: CGFloat = 8.0
}

final class CollectionHeaderView: UICollectionReusableView {

    // MARK: - Private Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.textColor = .white
        label.font = Constants.titleFont
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }

    // MARK: - Public Methods

    func setup(with title: String) {
        titleLabel.text = title
    }

    // MARK: - Private Methods

    private func setupUI() {
        backgroundColor = .black
        addSubview(titleLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalPadding),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalPadding),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -Constants.horizontalPadding)
        ])
    }
}

