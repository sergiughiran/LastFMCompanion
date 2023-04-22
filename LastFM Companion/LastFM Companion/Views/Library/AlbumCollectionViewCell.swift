//
//  AlbumCollectionViewCell.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 03.06.2021.
//

import UIKit
import AlamofireImage

private enum Constants {
    static let cornerRadius: CGFloat = 8.0
    static let animationDuration: Double = 0.33
    static let defaultImage: UIImage = UIImage(named: "defaultAlbumImage")!
}

final class AlbumCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var downloadedIcon: UIImageView!
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - Private Methods

    private func setupUI() {
        albumImageView.layer.cornerRadius = Constants.cornerRadius
        albumImageView.layer.masksToBounds = true
    }

    // MARK: - Public Methods

    func setup(with album: Album, isSaved: Bool) {
        albumImageView.image = Constants.defaultImage

        if let image = album.image {
            albumImageView.image = image
        } else if let imageUrlString = album.imageURL, let imageUrl = URL(string: imageUrlString) {
            albumImageView.af.setImage(withURL: imageUrl, placeholderImage: Constants.defaultImage, imageTransition: .crossDissolve(Constants.animationDuration))
        }
    
        albumTitleLabel.text = album.name
        artistNameLabel.text = album.artist
        downloadedIcon.isHidden = !isSaved
    }
}
