//
//  SearchService.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 06.06.2021.
//

class SearchService {

    // MARK: - Private Properties

    private let apiClient: APIClient

    // MARK: - Lifecycle

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    // MARK: - Public Methods

    func searchArtist(_ artist: String, page: Int, limit: Int, completion: @escaping (Result<Artists, APIError>) -> Void) {
        apiClient.execute(request: .searchArtist(artist, at: page, limit: limit), completion: completion)
    }
}

