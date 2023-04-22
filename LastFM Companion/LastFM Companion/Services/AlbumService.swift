//
//  AlbumService.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 12.06.2021.
//

import CoreData

class AlbumService {
    typealias AlbumContextDidChangeHandler = ([Album]) -> Void

    // MARK: - Private Properties

    private let apiClient: APIClient
    private let dataStore: DataStore
    private let localAlbums: LocalAlbums

    /// Very basic observable-type object that is used to notify the array items of a context change.
    var contextDidChangeHandlers: [AlbumContextDidChangeHandler] = []

    // MARK: - Lifecycle

    init(apiClient: APIClient = APIClient(), dataStore: DataStore = DataStore(), localAlbums: LocalAlbums = LocalAlbums()) {
        self.apiClient = apiClient
        self.dataStore = dataStore
        self.localAlbums = localAlbums

        // Sets the service as an observer for any add/remove/update operations happening inside Core Data
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Private Methods

    /// Notification handler for core data changes. Executes any context change handlers that have been passed using the `addContextDidChangeHandler` method.
    @objc private func contextDidChange() {
        guard !contextDidChangeHandlers.isEmpty else { return }

        let albums: [Album] = (try? dataStore.fetch(request: Album.fetchRequest())) ?? []
        contextDidChangeHandlers.forEach({ $0(albums) })
    }

    // MARK: - Public Methods

    /// Adds a new context handler to be notified if any add/remove/update operations happened in the Core Data stack.
    func addContextDidChangeHandler(_ handler: @escaping AlbumContextDidChangeHandler) {
        contextDidChangeHandlers.append(handler)
    }

    func getAlbumDetails(_ album: String, artist: String, completion: @escaping (Result<AlbumContainer, APIError>) -> Void) {
        apiClient.execute(request: .getAlbum(album, artist: artist), completion: completion)
    }

    func getAlbums() -> [Album]? {
        do {
            let albums: [Album] = try dataStore.fetch(request: Album.fetchRequest())
            localAlbums.add(albums)
            return albums
        } catch {
            return nil
        }
    }

    @discardableResult
    func saveAlbum(_ album: Album) -> Album? {
        do {
            try dataStore.save(album)
            localAlbums.add(album.id)
            return album
        } catch {
            return nil
        }
    }

    @discardableResult
    func removeAlbum(_ album: Album) -> Album? {
        do {
            try dataStore.delete(album)
            localAlbums.remove(album.id)
            return album
        } catch {
            return nil
        }
    }
}
