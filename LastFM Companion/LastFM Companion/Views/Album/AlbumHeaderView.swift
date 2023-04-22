//
//  AlbumHeaderView.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 12.06.2021.
//

import UIKit

private enum Constants {
    static let cornerRadius: CGFloat = 8.0
    static let defaultImage: UIImage = UIImage(named: "defaultAlbumImage")!
}

protocol AlbumHeaderViewDelegate: AnyObject {
    func handleSave()
    func handleInfo()
}

final class AlbumHeaderView: UIView {
    
    // MARK: - Outlets

    @IBOutlet private weak var albumImageView: UIImageView!
    @IBOutlet private weak var albumNameLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var saveButton: AlbumActionButton!
    @IBOutlet private weak var infoButton: AlbumActionButton!

    // MARK: - Public Properties

    weak var delegate: AlbumHeaderViewDelegate?

    // MARK: - Lifecycle

    class func instanceFromNib() -> AlbumHeaderView {
        let nib = UINib(nibName: "AlbumHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AlbumHeaderView
        nib.setupUI()
        return nib
    }

    // MARK: - Public Methods

    func setup(with album: Album, isSaved: Bool) {
        albumImageView.image = Constants.defaultImage

        if let image = album.image {
            albumImageView.image = image
        } else if let imageString = album.imageURL, let imageUrl = URL(string: imageString) {
            albumImageView.af.setImage(withURL: imageUrl, placeholderImage: Constants.defaultImage, imageTransition: .crossDissolve(0.33))
        }

        albumNameLabel.text = album.name
        artistNameLabel.text = album.artist

        infoButton.isHidden = album.info == nil
        infoButton.setup(with: .info)
        saveButton.setup(with: isSaved ? .remove : .save)

        layoutIfNeeded()
    }

    func updateSaved(isSaved: Bool) {
        saveButton.updateSaved(isSaved: isSaved)
    }

    // MARK: - Private Methods

    private func setupUI() {
        albumImageView.layer.cornerRadius = Constants.cornerRadius
        albumImageView.layer.masksToBounds = true

        saveButton.layer.cornerRadius = Constants.cornerRadius
        saveButton.layer.masksToBounds = true
        infoButton.layer.cornerRadius = Constants.cornerRadius
        infoButton.layer.masksToBounds = true
    }

    @IBAction func didTapSaveButton(_ sender: AlbumActionButton) {
        delegate?.handleSave()
    }
    
    @IBAction func didTapInfoButton(_ sender: AlbumActionButton) {
        delegate?.handleInfo()
    }
}
