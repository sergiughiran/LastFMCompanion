//
//  SearchCoordinator.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 09.06.2021.
//

import UIKit

final class AlbumDiscoveryCoordinator: Coordinator {

    // MARK: - Private Properties

    private let dataStore: DataStore
    private let apiClient: APIClient
    private let localAlbums: LocalAlbums

    // MARK: - Public Properties

    var presenter: UINavigationController
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController?

    // MARK: - Lifecycle

    init(dataStore: DataStore, apiClient: APIClient, localAlbums: LocalAlbums, presenter: UINavigationController) {
        self.dataStore = dataStore
        self.apiClient = apiClient
        self.localAlbums = localAlbums
        self.presenter = presenter
    }

    // MARK: - Public Methods

    func start() {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }

        let service = SearchService()

        let viewModel = SearchViewModel(service: service)
        viewModel.delegate = self

        viewController.viewModel = viewModel

        presenter.pushViewController(viewController, animated: true)
        rootViewController = viewController
    }
}

extension AlbumDiscoveryCoordinator: SearchViewModelDelegate {
    func showArtist(_ artist: Artist) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ArtistViewController") as? ArtistViewController else { return }

        let service = ArtistService()
        let viewModel = ArtistViewModel(artist: artist, service: service, localAlbums: localAlbums)
        viewModel.flowDelegate = self
        viewController.viewModel = viewModel

        presenter.pushViewController(viewController, animated: true)
    }
}

extension AlbumDiscoveryCoordinator: ArtistViewModelFlowDelegate {
    func showAlbumDetail(_ album: Album) {
        guard let viewController = AlbumDetailViewController.instantiateFromStoryboard() else { return }

        let service = AlbumService(apiClient: apiClient, dataStore: dataStore)
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
