//
//  ArtistViewModel.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 09.06.2021.
//

protocol ArtistViewModelFlowDelegate: AnyObject {
    func showAlbumDetail(_ album: Album)
}

final class ArtistViewModel {

    // MARK: - Public Properties

    weak var flowDelegate: ArtistViewModelFlowDelegate?

    /// Handler closure that is called whenever Core Data performs a add/remove/update operation.
    var contextDidChangeHandler: (() -> Void)?

    var artist: Artist
    var topAlbums: [Album] = []
    var localAlbums: LocalAlbums

    // MARK: - Private Properties

    private let artistService: ArtistService
    private let albumService: AlbumService

    // MARK: - Lifecycle

    init(artist: Artist, artistService: ArtistService, albumService: AlbumService, localAlbums: LocalAlbums) {
        self.artist = artist
        self.artistService = artistService
        self.albumService = albumService
        self.localAlbums = localAlbums

        // We don't care about the album list here since we already have a reference to the local album ids.
        let contextDidChangeHandler: ([Album]) -> Void = { [weak self] _ in
            self?.contextDidChangeHandler?()
        }

        albumService.addContextDidChangeHandler(contextDidChangeHandler)
    }

    // MARK: - Public Methods

    /// Method resposible for starting the top album fetch process.
    func getTopAlbums(completion: @escaping (Result<[Album], APIError>) -> Void) {
        artistService.getTopAlbums(of: artist.name) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let topAlbums):
                self.topAlbums = topAlbums.all
                completion(.success(topAlbums.all))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func showAlbumDetail(at index: Int) {
        flowDelegate?.showAlbumDetail(topAlbums[index])
    }
}
