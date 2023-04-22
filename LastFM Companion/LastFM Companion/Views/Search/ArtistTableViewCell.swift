//
//  ArtistTableViewCell.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 05.06.2021.
//

import UIKit

private enum Constants {
    static let cornerRadius: CGFloat = 8.0
    static let animationDuration: Double = 0.33
    static let defaultImage: UIImage = UIImage(named: "defaultArtistImage")!
}

final class ArtistTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet private weak var artistImageView: UIImageView!
    @IBOutlet private weak var artistNameLabel: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - Public Methods

    func setup(with model: Artist) {
        artistImageView.image = Constants.defaultImage

        if let imageUrlString = model.imageURL,
              let imageUrl = URL(string: imageUrlString) {
            artistImageView.af.setImage(withURL: imageUrl, placeholderImage: Constants.defaultImage, imageTransition: .crossDissolve(Constants.animationDuration))
        }

        artistNameLabel.text = model.name
    }

    // MARK: - Private Methods

    private func setupUI() {
        artistImageView.layer.cornerRadius = Constants.cornerRadius
        artistImageView.layer.masksToBounds = true
    }
}
