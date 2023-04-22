//
//  ImageManager.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 14.06.2021.
//

import AlamofireImage

/// Singleton manager wrapping the `imageDownloader` and `cache` properties around `AlamofireImage`. This is used to set a new imageDownloader as the default for the `UIImageView` extension and to maintain a reference to the `cache` used by the framework. The cache is used so that there is no longer a need to re-fetch the image from the internet.
final class ImageManager {

    // MARK: - Private Properties

    private lazy var imageDownloader: ImageDownloader = {
        let imageDownloader = ImageDownloader(
            configuration: ImageDownloader.defaultURLSessionConfiguration(),
            downloadPrioritization: .fifo,
            maximumActiveDownloads: 4,
            imageCache: cache
        )

        return imageDownloader
    }()

    private lazy var cache: AutoPurgingImageCache = AutoPurgingImageCache()

    // MARK: - Shared

    static var shared = ImageManager()

    // MARK: - Lifecycle

    private init() {}

    // MARK: - Public Methods

    /// Sets the pre-configured `imageDownloader` as the default for the `UIImageView` extension
    func setup() {
        UIImageView.af.sharedImageDownloader = imageDownloader
    }

    /// Fetches the cached image keyed by it's `urlString` property.
    func getCachedImage(with urlString: String) -> UIImage? {
        return cache.image(withIdentifier: urlString)
    }
}
