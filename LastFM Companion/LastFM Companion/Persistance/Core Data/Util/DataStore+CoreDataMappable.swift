//
//  DataStore+CoreDataMappable.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 31.05.2021.
//

import CoreData

protocol CoreDataMappable: Identifiable {
    associatedtype T: NSManagedObject

    @discardableResult
    func mapDataModel(context: NSManagedObjectContext) -> T
    static func fetchRequest() -> NSFetchRequest<T>
}

extension Track: CoreDataMappable {
    func mapDataModel(context: NSManagedObjectContext) -> TrackDataModel {
        let dataModel = TrackDataModel(context: context)

        dataModel.id = id
        dataModel.name = name
        dataModel.duration = Int64(duration)
        dataModel.rank = rank
        dataModel.artist = artist

        return dataModel
    }

    static func fetchRequest() -> NSFetchRequest<TrackDataModel> {
        return TrackDataModel.fetchRequest()
    }
}

extension Album: CoreDataMappable {
    func mapDataModel(context: NSManagedObjectContext) -> AlbumDataModel {
        let dataModel = AlbumDataModel(context: context)

        dataModel.id = id
        dataModel.name = name
        dataModel.artist = artist
        dataModel.imageURL = imageURL
        dataModel.info = info

        if let imageURL = imageURL, let image = ImageManager.shared.getCachedImage(with: imageURL) {
            dataModel.image = image.jpegData(compressionQuality: 1.0)
        }

        tracks?.forEach({ track in
            let trackDataModel = track.mapDataModel(context: context)
            dataModel.addToTracks(trackDataModel)
        })

        return dataModel
    }

    static func fetchRequest() -> NSFetchRequest<AlbumDataModel> {
        return AlbumDataModel.fetchRequest()
    }
}
