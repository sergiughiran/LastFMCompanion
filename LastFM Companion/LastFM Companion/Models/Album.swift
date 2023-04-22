//
//  Album.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 31.05.2021.
//

import UIKit

struct Album: Decodable, Identifiable, Equatable {

    // MARK: - Properties

    var id: String
    let name: String
    let artist: String
    let imageURL: String?
    let tracks: [Track]?
    let info: String?

    var isSaved: Bool = false
    var image: UIImage? = nil

    // MARK: - Coding Keys

    enum CodingKeys: String, CodingKey {
        case name
        case artist
        case images = "image"
        case tracks
        case info = "wiki"
    }

    enum TrackCodingKeys: String, CodingKey {
        case track
    }

    enum ArtistCodingKeys: String, CodingKey {
        case name
    }

    enum DescriptionCodingKeys: String, CodingKey {
        case content
    }

    // MARK: - Lifecycle

    init(id: String, name: String, artist: String, imageURL: String?, tracks: [Track]?, description: String?, image: UIImage?) {
        self.id = id
        self.name = name
        self.artist = artist
        self.imageURL = imageURL
        self.tracks = tracks
        self.info = description
        self.image = image
    }

    // MARK: - Decodable

    init(from decoder: Decoder) throws {
        let albumContainer = try decoder.container(keyedBy: CodingKeys.self)
        name = try albumContainer.decode(String.self, forKey: .name)

        if let artistContainer = try? albumContainer.nestedContainer(keyedBy: ArtistCodingKeys.self, forKey: .artist) {
            artist = try artistContainer.decode(String.self, forKey: .name)
        } else {
            artist = try albumContainer.decode(String.self, forKey: .artist)
        }

        let images = try albumContainer.decode([Image].self, forKey: .images)
        imageURL = images.first(where: { $0.size == .extralarge })?.urlString

        if let tracksContainer = try? albumContainer.nestedContainer(keyedBy: TrackCodingKeys.self, forKey: .tracks) {
            tracks = try tracksContainer.decode([Track].self, forKey: .track)
        } else {
            tracks = nil
        }

        if let descriptionContainer = try? albumContainer.nestedContainer(keyedBy: DescriptionCodingKeys.self, forKey: .info) {
            info = try descriptionContainer.decode(String.self, forKey: .content)
        } else {
            info = nil
        }

        id = name + artist
    }
}

struct AlbumContainer: Decodable {
    var album: Album
}
