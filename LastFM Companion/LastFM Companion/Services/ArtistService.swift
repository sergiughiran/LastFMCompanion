//
//  ArtistService.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 10.06.2021.
//

import Foundation

class ArtistService {

    // MARK: - Private Properties

    private let apiClient: APIClient

    // MARK: - Lifecycle

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    // MARK: - Public Methods

    func getTopAlbums(of artist: String, completion: @escaping (Result<TopAlbums, APIError>) -> Void) {
        apiClient.execute(request: .getTopAlbums(of: artist), completion: completion)
    }
}
