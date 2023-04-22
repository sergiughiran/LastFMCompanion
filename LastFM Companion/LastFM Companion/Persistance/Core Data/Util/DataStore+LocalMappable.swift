//
//  DataStore+LocalMappable.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 31.05.2021.
//

import UIKit

protocol LocalMappable {
    associatedtype T: CoreDataMappable
    func mapLocalModel() -> T?
}

extension TrackDataModel: LocalMappable {
    func mapLocalModel() -> Track? {
        guard let id = id,
              let name = name,
              let rank = rank,
              let artist = artist
        else { return nil }

        return Track(id: id, name: name, duration: Int(duration), rank: rank, artist: artist)
    }
}

extension AlbumDataModel: LocalMappable {
    func mapLocalModel() -> Album? {
        guard let id = id,
              let name = name,
              let artist = artist
        else { return nil }

        let mappedTracks = (tracks?.allObjects as? [TrackDataModel])?.compactMap({ $0.mapLocalModel() }).sorted(by: { Int($0.rank)! < Int($1.rank)! })

        var image: UIImage? = nil
        if let imageData = self.image,
           let renderedImage = UIImage(data: imageData) {
            image = renderedImage
        }
        
        return Album(id: id, name: name, artist: artist, imageURL: imageURL, tracks: mappedTracks, description: info, image: image)
    }
}
