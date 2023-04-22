//
//  DataStoreMock.swift
//  LastFM CompanionTests
//
//  Created by Ghiran Sergiu on 17.06.2021.
//

import CoreData
@testable import LastFM_Companion

class DataStoreMock: DataStore {
    override func prepare() {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        persistentContainer = NSPersistentContainer(name: "LastFM_Companion")

        persistentContainer.persistentStoreDescriptions = [persistentStoreDescription]
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
