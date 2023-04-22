//
//  LocalAlbums.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 14.06.2021.
//

import Foundation

private enum Constants {
    static let key = "localAlbums"
}

/// Class used to store the saved albums `id` properties. Used to check what albums are saved locally after they are loaded in memory.
final class LocalAlbums {

    // MARK: - Private Properties

    private let userDefaults = UserDefaults.standard

    // MARK: - Public Properties

    private(set) var albumIDs: [String]

    // MARK: - Lifecycle

    init() {
        albumIDs = (userDefaults.array(forKey: Constants.key) as? [String]) ?? []
    }

    // MARK: - Public Methods

    func add(_ albums: [Album]) {
        let mappedValues = albums.map({ $0.id })
        albumIDs = mappedValues
        userDefaults.setValue(albumIDs, forKey: Constants.key)
    }

    func add(_ albumID: String) {
        albumIDs.append(albumID)
        userDefaults.setValue(albumIDs, forKey: Constants.key)
    }

    func remove(_ albumID: String) {
        guard let index = albumIDs.firstIndex(of: albumID) else { return }

        albumIDs.remove(at: index)
        userDefaults.setValue(albumIDs, forKey: Constants.key)
    }
}
