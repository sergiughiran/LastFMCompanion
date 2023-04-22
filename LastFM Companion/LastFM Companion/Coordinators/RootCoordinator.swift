//
//  RootCoordinator.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 09.06.2021.
//

import UIKit

final class RootCoordinator: Coordinator {

    // MARK: - Private Properties

    private let dataStore: DataStore
    private let apiClient = APIClient()
    private let localAlbums = LocalAlbums()

    // MARK: - Public Properties

    var presenter: UINavigationController
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController?

    // MARK: - Lifecycle

    init(presenter: UINavigationController, dataStore: DataStore) {
        self.presenter = presenter
        self.dataStore = dataStore
        configureNavigationBar()
    }

    // MARK: - Public Methods

    func start() {
        let libraryCoordinator = LibraryCoordinator(presenter: presenter, dataStore: dataStore, apiClient: apiClient, localAlbums: localAlbums)
        childCoordinators.append(libraryCoordinator)
        libraryCoordinator.start()
    }

    // MARK: - Private Methods

    private func configureNavigationBar() {
        presenter.navigationBar.setBackgroundImage(UIImage(), for: .default)
        presenter.navigationBar.shadowImage = UIImage()
        presenter.navigationBar.backgroundColor = .clear
        presenter.navigationBar.isTranslucent = true
        presenter.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        presenter.navigationBar.tintColor = .white
    }
}
