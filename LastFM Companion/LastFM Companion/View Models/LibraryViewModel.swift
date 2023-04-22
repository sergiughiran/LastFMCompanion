//
//  LibraryViewModel.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 04.06.2021.
//

protocol LibraryViewModelFlowDelegate: AnyObject {
    func showSearch()
    func showAlbumDetail(_ album: Album)
}

final class LibraryViewModel {

    // MARK: - Public Properties

    weak var flowDelegate: LibraryViewModelFlowDelegate?

    var albums = [Album]()
    /// Handler closure that is called whenever Core Data performs a add/remove/update operation and that returns the new locally stored album list.
    var contextDidChangeHandler: (([Album]) -> Void)?

    // MARK: - Private Properties

    private let service: AlbumService

    // MARK: - Lifecycle

    init(service: AlbumService) {
        self.service = service

        let contextDidChangeHandler: ([Album]) -> Void = { [weak self] albums in
            guard let self = self else { return }

            self.albums = self.orderedAlbums(albums)
            self.contextDidChangeHandler?(self.albums)
        }

        service.addContextDidChangeHandler(contextDidChangeHandler)
    }

    // MARK: - Public Methods

    func loadData(completion: @escaping (Result<[Album], CDError>) -> Void) {
        guard let albums = service.getAlbums() else {
            completion(.failure(.fetchError))
            return
        }

        self.albums = orderedAlbums(albums)
        completion(.success(self.albums))
    }

    func didSelectSearch() {
        flowDelegate?.showSearch()
    }

    func didSelectAlbum(at index: Int) {
        flowDelegate?.showAlbumDetail(albums[index])
    }

    // MARK: - Private Methods

    /// Helper method for grouping albums by artist name and sorting alphabetically by album name.
    private func orderedAlbums(_ albums: [Album]) -> [Album] {
        return albums.sorted(by: {
            $0.artist != $1.artist ? $0.artist < $1.artist : $0.name < $1.name
        })
    }
}
