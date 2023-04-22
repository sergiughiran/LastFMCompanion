//
//  Artist.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 31.05.2021.
//

struct Artist: Decodable, Equatable {
    let name: String
    let listeners: String
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case name
        case listeners
        case imageURL = "image"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        listeners = try container.decode(String.self, forKey: .listeners)

        let imageURLs = try container.decode([Image].self, forKey: .imageURL)
        imageURL = imageURLs.first(where: { $0.size == .extralarge })?.urlString
    }

    init(name: String, listeners: String, imageURL: String?) {
        self.name = name
        self.listeners = listeners
        self.imageURL = imageURL
    }
}

struct Artists: Decodable, Equatable {

    // MARK: - Properties

    let all: [Artist]
    let totalCount: String

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case all = "artistmatches"
        case totalCount = "opensearch:totalResults"
    }

    enum ContainerCodingKeys: String, CodingKey {
        case results
    }

    enum NestedKeys: String, CodingKey {
        case artist
    }

    // MARK: - Decodable

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContainerCodingKeys.self)

        let artistContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .results)
        totalCount = try artistContainer.decode(String.self, forKey: .totalCount)

        let nestedContainer = try artistContainer.nestedContainer(keyedBy: NestedKeys.self, forKey: .all)
        all = try nestedContainer.decode([Artist].self, forKey: .artist)
    }

    init(all: [Artist], totalCount: String) {
        self.all = all
        self.totalCount = totalCount
    }
}
