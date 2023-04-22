//
//  TopAlbums.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 10.06.2021.
//

import Foundation

struct TopAlbums: Decodable {

    // MARK: - Public Properties

    var all: [Album]

    // MARK: - Coding Keys

    enum CodingKeys: String, CodingKey {
        case all = "topalbums"
    }

    enum NestedCodingKeys: String, CodingKey {
        case album
    }

    // MARK: - Decodable

    init(from decoder: Decoder) throws {
        let contaier = try decoder.container(keyedBy: CodingKeys.self)
        let albumsContainer = try contaier.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .all)

        all = try albumsContainer.decode([Album].self, forKey: .album)
    }

    init(all: [Album]) {
        self.all = all
    }
}
