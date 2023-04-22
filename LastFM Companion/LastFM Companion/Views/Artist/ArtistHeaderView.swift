//
//  ArtistHeaderView.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 08.06.2021.
//

import UIKit

private enum Constants {
    static let animationDuration: TimeInterval = 0.33
    static let defaultImage: UIImage? = UIImage(named: "defaultArtistImage")
}

/// View meant to be used as a animatable header inside a `UICollectionView`. You set this view as the background view of the collectionView and call the appropriate methods in order to enable the dynamic appearance updates.
final class ArtistHeaderView: UIView {

    // MARK: - Outlets

    @IBOutlet private weak var artistImageView: UIImageView!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var listenersLabel: UILabel!
    @IBOutlet private weak var artistInfoStackView: UIStackView!
    
    // MARK: - Public Properties

    var height: CGFloat?
    var minHeight: CGFloat?

    // MARK: - Private Properties

    private lazy var gradientLayer: CAGradientLayer = {
        let gradientOverlay = CAGradientLayer()

        gradientOverlay.frame = artistImageView.bounds
        gradientOverlay.startPoint = CGPoint(x: 0.5, y: 0)
        gradientOverlay.endPoint = CGPoint(x: 0.5, y: 1)
        gradientOverlay.locations = [0, 1]
        gradientOverlay.colors = [
            UIColor.black.withAlphaComponent(0.25).cgColor,
            UIColor.black.withAlphaComponent(1.0).cgColor
        ]
        gradientOverlay.isOpaque = false

        return gradientOverlay
    }()

    // MARK: - Lifecycle

    class func instanceFromNib() -> ArtistHeaderView {
        let nib = UINib(nibName: "ArtistHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ArtistHeaderView
        nib.setupUI()
        return nib
    }

    // MARK: - Public Methods

    func setup(with artist: Artist) {
        if let imageUrlString = artist.imageURL,
           let imageUrl = URL(string: imageUrlString) {
            artistImageView.af.setImage(withURL: imageUrl, placeholderImage: Constants.defaultImage, imageTransition: .crossDissolve(Constants.animationDuration))
        } else {
            artistImageView.image = Constants.defaultImage
        }

        artistNameLabel.text = artist.name
        listenersLabel.text = ListenersFormatter.formattedValue(Int(artist.listeners) ?? 0)
    }

    /// Dynamically updates the appearance of the header based on the offset of the containing `UITableView`
    func updateAppearance(with offset: CGFloat) {
        guard let height = height, let minHeight = minHeight, offset > minHeight else { return }

        let referenceHeight = height - minHeight
        let referenceOffset = offset - minHeight

        let alpha = referenceOffset / referenceHeight

        artistImageView.alpha = alpha
        artistNameLabel.alpha = alpha
        listenersLabel.alpha = alpha
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Needed because the CALayer has, by default, some sort of animation added to all of the frame/bounds updates. This overwrites these animations.
        CATransaction.begin()
        CATransaction.setAnimationDuration(0)
        gradientLayer.frame = artistImageView.layer.bounds
        CATransaction.commit()
    }

    // MARK: - Private Methods

    private func setupUI() {
        artistImageView.layer.addSublayer(gradientLayer)
    }
}
