//
//  RecentSearches.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 05.06.2021.
//

import Foundation

private enum Constants {
    static let defaultLimit = 20
    static let key = "recentSearches"
}

/// Container object responsible for storing and offering an in memory representation of the recent searches cut by a specified item limit.
struct RecentSearches {

    // MARK: - Private Properties

    private let userDefaults = UserDefaults.standard
    private var limit: Int

    // MARK: - Public Properties

    private(set) var searches: [String]

    // MARK: - Lifecycle

    init(limit: Int = Constants.defaultLimit) {
        self.limit = limit
        searches = (userDefaults.array(forKey: Constants.key) as? [String]) ?? []
    }

    // MARK: - Public Methods

    mutating func add(_ searchString: String) {
        if let existingIndex = searches.firstIndex(of: searchString) {
            searches.remove(at: existingIndex)
        }

        searches.insert(searchString, at: 0)
        if searches.count > limit {
            searches.removeSubrange(limit..<searches.count)
        }

        userDefaults.setValue(searches, forKey: Constants.key)
    }

    mutating func remove(at index: Int) {
        guard index < searches.count else {
            return
        }

        searches.remove(at: index)
        userDefaults.setValue(searches, forKey: Constants.key)
    }
}
