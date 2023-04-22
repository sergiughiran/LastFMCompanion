//
//  AlbumDetailViewModel.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 12.06.2021.
//

protocol AlbumDetailViewModelDelegate: AnyObject {
    func showInfo(_ info: String, title: String)
}

final class AlbumDetailViewModel {

    // MARK: - Public Properties

    weak var delegate: AlbumDetailViewModelDelegate?

    /// The fetched album. This property is set either if the album was previously saved locally or if it was fetched from the API.
    var album: Album?
    var isSaved: Bool {
        guard let album = album else { return false }
        return localAlbums.albumIDs.contains(album.id)
    }

    // MARK: - Private Properties

    // The top album. This property is set when opening the screen from an artist.
    private var topAlbum: Album?
    private var service: AlbumService?
    private var localAlbums: LocalAlbums

    // MARK: - Lifecycle

    init(album: Album? = nil, topAlbum: Album? = nil , service: AlbumService, localAlbums: LocalAlbums) {
        self.album = album
        self.topAlbum = topAlbum
        self.service = service
        self.localAlbums = localAlbums
    }

    // MARK: - Public Methods

    /// Method responsible for starting the album detail fetch process and handling the response.
    func getAlbumDetails(completion: @escaping (Result<Album, APIError>) -> Void) {
        guard let topAlbum = topAlbum else {
            if let album = album {
                completion(.success(album))
            }

            return
        }

        service?.getAlbumDetails(topAlbum.name, artist: topAlbum.artist) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let albumContainer):
                self.album = albumContainer.album
                completion(.success(albumContainer.album))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func handleInfo() {
        guard let info = album?.info, let title = album?.name else { return }
        delegate?.showInfo(info, title: title)
    }

    /// Method resposible with saving/removing an album from the local storage and for updating the `LocalAlbums` object.
    func handleSave(completion: @escaping (Result<Bool, CDError>) -> Void) {
        guard let album = album, let service = service else { return }

        guard (isSaved ? service.removeAlbum(album) : service.saveAlbum(album)) != nil else {
            completion(.failure(isSaved ? .removeError : .saveError))
            return
        }

        completion(.success(isSaved))
    }
}
