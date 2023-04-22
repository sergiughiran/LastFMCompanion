//
//  SearchViewModel.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 06.06.2021.
//

import Foundation

private enum Constants {
    static let pageLimit: Int = 50
}

protocol SearchViewModelDelegate: AnyObject {
    func showArtist(_ artist: Artist)
}

final class SearchViewModel {

    // MARK: - Result Type

    enum ResultType {
        case recentSearches, artist, none

        var title: String {
            switch self {
            case .recentSearches:
                return "Recent searches"
            case .artist:
                return "Search results"
            case .none:
                return ""
            }
        }
    }

    // MARK: - Public Properties

    weak var delegate: SearchViewModelDelegate?

    private(set) var searchResults = [Artist]()
    private(set) var recentSearches = RecentSearches()

    var resultType: ResultType {
        var result = ResultType.none
    
        if !searchResults.isEmpty {
            result = .artist
        } else if !recentSearches.searches.isEmpty {
            result = .recentSearches
        }

        return result
    }

    // MARK: - Private Properties

    private let searchService: SearchService

    private var totalCount = 0
    private var currentPage = 1
    private var searchString = ""
    private var isFetching = false

    // MARK: - Lifecycle

    init(service: SearchService) {
        self.searchService = service
    }

    // MARK: - Public Methods

    // TODO: - Check the result
    /// Method used for requesting the first page of artists based on the search criteria.
    func searchArtist(_ artist: String, completion: @escaping (Result<[Artist], APIError>) -> Void) {
        searchString = artist
        currentPage = 1

        guard !artist.isEmpty else {
            clearArtists()
            completion(.success([]))
            return
        }

        searchService.searchArtist(artist, page: currentPage, limit: Constants.pageLimit) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let artists):
                self.totalCount = Int(artists.totalCount) ?? 0
                self.searchResults = artists.all

                self.currentPage += 1
                completion(.success(artists.all))
            case .failure(let error):
                self.searchResults = []
                completion(.failure(error))
            }
        }
    }

    /// Method used for requesting next paginated search results.
    func loadNextPage(completion: @escaping (Result<[Artist], APIError>) -> Void) {
        guard !isFetching, searchResults.count < totalCount else { return }

        isFetching = true
        searchService.searchArtist(searchString, page: currentPage, limit: Constants.pageLimit) { [weak self] result in
            guard let self = self else { return }

            self.isFetching = false

            switch result {
            case .success(let artists):
                self.searchResults.append(contentsOf: artists.all)
                self.currentPage += 1
                completion(.success(self.searchResults))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Method helper responsible with adding a new search string to the recent searches object.
    func selectArtist(_ artist: Artist) {
        recentSearches.add(artist.name)
        delegate?.showArtist(artist)
    }

    func clearArtists() {
        searchResults = []
    }

    func removeRecentSearch(at index: Int) {
        recentSearches.remove(at: index)
    }
}
