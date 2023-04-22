//
//  AlbumDiscoveryCoordinator.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 09.06.2021.
//

import UIKit

final class AlbumDiscoveryCoordinator: Coordinator {

    // MARK: - Private Properties

    private let dataStore: DataStore
    private let albumService: AlbumService
    private let apiClient: APIClient
    private let localAlbums: LocalAlbums

    // MARK: - Public Properties

    var presenter: UINavigationController
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController?

    // MARK: - Lifecycle

    init(dataStore: DataStore, apiClient: APIClient, albumService: AlbumService, localAlbums: LocalAlbums, presenter: UINavigationController) {
        self.dataStore = dataStore
        self.albumService = albumService
        self.apiClient = apiClient
        self.localAlbums = localAlbums
        self.presenter = presenter
    }

    // MARK: - Public Methods

    func start() {
        guard let viewController = SearchViewController.instantiateFromStoryboard() else { return }

        let service = SearchService(apiClient: apiClient)
        let viewModel = SearchViewModel(service: service)
        viewModel.delegate = self

        viewController.viewModel = viewModel
        presenter.pushViewController(viewController, animated: true)

        rootViewController = viewController
    }
}

extension AlbumDiscoveryCoordinator: SearchViewModelDelegate {
    func showArtist(_ artist: Artist) {
        guard let viewController = ArtistViewController.instantiateFromStoryboard() else { return }

        let service = ArtistService(apiClient: apiClient)
        let viewModel = ArtistViewModel(artist: artist, artistService: service, albumService: albumService, localAlbums: localAlbums)
        viewModel.flowDelegate = self

        viewController.viewModel = viewModel
        presenter.pushViewController(viewController, animated: true)
    }
}

extension AlbumDiscoveryCoordinator: ArtistViewModelFlowDelegate {
    func showAlbumDetail(_ album: Album) {
        guard let viewController = AlbumDetailViewController.instantiateFromStoryboard() else { return }

        let service = AlbumService(apiClient: apiClient, dataStore: dataStore, localAlbums: localAlbums)
        let viewModel = AlbumDetailViewModel(topAlbum: album, service: service, localAlbums: localAlbums)
        viewModel.delegate = self

        viewController.viewModel = viewModel
        presenter.pushViewController(viewController, animated: true)
    }
}

extension AlbumDiscoveryCoordinator: AlbumDetailViewModelDelegate {
    func showInfo(_ info: String, title: String) {
        guard let viewController = InfoViewController.instantiateFromStoryboard() else { return }

        let viewModel = InfoViewModel(title: title, info: info)
        viewController.viewModel = viewModel

        presenter.present(viewController, animated: true)
    }
}
