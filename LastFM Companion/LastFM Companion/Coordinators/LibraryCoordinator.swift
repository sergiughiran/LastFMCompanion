//
//  LibraryCoordinator.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 09.06.2021.
//

import UIKit

final class LibraryCoordinator: NSObject, Coordinator {

    // MARK: - Private Properties

    private let dataStore: DataStore
    private let apiClient: APIClient
    private let service: AlbumService
    private let localAlbums: LocalAlbums

    // MARK: - Public Properties

    var presenter: UINavigationController
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController?

    // MARK: - Lifecycle

    init(presenter: UINavigationController, dataStore: DataStore, apiClient: APIClient, localAlbums: LocalAlbums) {
        self.presenter = presenter
        self.dataStore = dataStore
        self.apiClient = apiClient
        self.localAlbums = localAlbums

        self.service = AlbumService(apiClient: apiClient, dataStore: dataStore, localAlbums: localAlbums)
    }

    // MARK: - Public Methods

    func start() {
        guard let viewController = LibraryViewController.instantiateFromStoryboard() else { return }

        let viewModel = LibraryViewModel(service: service)
        viewModel.flowDelegate = self

        viewController.viewModel = viewModel
        presenter.pushViewController(viewController, animated: true)
        presenter.delegate = self

        self.rootViewController = viewController
    }
}

extension LibraryCoordinator: UINavigationControllerDelegate {
    /// Delegate method used to dynamically close finished child coordinators by checking the navigation stack.
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(fromViewController)
        else { return }

        if let coordinator = childCoordinators.last(where: { $0.rootViewController === fromViewController }) {
            childDidFinnish(coordinator)
        }
    }
}

extension LibraryCoordinator: LibraryViewModelFlowDelegate {
    func showSearch() {
        let searchCoordinator = AlbumDiscoveryCoordinator(dataStore: dataStore, apiClient: apiClient, albumService: service, localAlbums: localAlbums, presenter: presenter)
        childCoordinators.append(searchCoordinator)
        searchCoordinator.start()
    }

    func showAlbumDetail(_ album: Album) {
        guard let viewController = AlbumDetailViewController.instantiateFromStoryboard() else { return }

        let viewModel = AlbumDetailViewModel(album: album, service: service, localAlbums: localAlbums)
        viewModel.delegate = self

        viewController.viewModel = viewModel
        presenter.pushViewController(viewController, animated: true)
    }
}

extension LibraryCoordinator: AlbumDetailViewModelDelegate {
    func showInfo(_ info: String, title: String) {
        guard let viewController = InfoViewController.instantiateFromStoryboard() else { return }

        let viewModel = InfoViewModel(title: title, info: info)
        viewController.viewModel = viewModel

        presenter.present(viewController, animated: true)
    }
}


