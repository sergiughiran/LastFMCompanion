//
//  Track.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 31.05.2021.
//

struct Track: Decodable, Identifiable, Equatable {

    // MARK: - Public Properties

    var id: String
    let name: String
    let duration: Int
    let rank: String
    let artist: String

    // MARK: - Coding Keys

    enum CodingKeys: String, CodingKey {
        case name
        case duration
        case rank = "@attr"
        case artist
    }

    enum RankCodingKeys: String, CodingKey {
        case rank
    }

    enum ArtistCodingKeys: String, CodingKey {
        case name
    }

    // MARK: - Decodable

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        duration = try container.decode(Int.self, forKey: .duration)

        let rankContainer = try container.nestedContainer(keyedBy: RankCodingKeys.self, forKey: .rank)
        rank = try rankContainer.decode(String.self, forKey: .rank)

        let artistContainer = try container.nestedContainer(keyedBy: ArtistCodingKeys.self, forKey: .artist)
        artist = try artistContainer.decode(String.self, forKey: .name)

        id = name + artist
    }

    // MARK: - Lifecycle

    init(id: String, name: String, duration: Int, rank: String, artist: String) {
        self.id = id
        self.name = name
        self.duration = duration
        self.rank = rank
        self.artist = artist
    }
}
