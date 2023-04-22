//
//  InfoViewModel.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 14.06.2021.
//

final class InfoViewModel {

    // MARK: - Public Properties

    var title: String
    var info: String

    // MARK: - Lifecycle

    init(title: String, info: String) {
        self.title = title
        self.info = info
    }
}
