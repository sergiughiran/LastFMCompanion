//
//  TrackDataModel+CoreDataProperties.swift
//  
//
//  Created by Ghiran Sergiu on 22.04.2023.
//
//

import Foundation
import CoreData


extension TrackDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackDataModel> {
        return NSFetchRequest<TrackDataModel>(entityName: "TrackDataModel")
    }

    @NSManaged public var artist: String?
    @NSManaged public var duration: Int64
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var rank: String?
    @NSManaged public var album: AlbumDataModel?

}
