//
//  AlbumDataModel+CoreDataProperties.swift
//  
//
//  Created by Ghiran Sergiu on 16.06.2021.
//
//

import Foundation
import CoreData


extension AlbumDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlbumDataModel> {
        return NSFetchRequest<AlbumDataModel>(entityName: "AlbumDataModel")
    }

    @NSManaged public var artist: String?
    @NSManaged public var name: String?
    @NSManaged public var info: String?
    @NSManaged public var image: Data?
    @NSManaged public var imageURL: String?
    @NSManaged public var id: String?
    @NSManaged public var tracks: NSSet?

}

// MARK: Generated accessors for tracks
extension AlbumDataModel {

    @objc(addTracksObject:)
    @NSManaged public func addToTracks(_ value: TrackDataModel)

    @objc(removeTracksObject:)
    @NSManaged public func removeFromTracks(_ value: TrackDataModel)

    @objc(addTracks:)
    @NSManaged public func addToTracks(_ values: NSSet)

    @objc(removeTracks:)
    @NSManaged public func removeFromTracks(_ values: NSSet)

}
