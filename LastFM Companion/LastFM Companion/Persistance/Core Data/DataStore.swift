//
//  DataStore.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 30.05.2021.
//

import CoreData

 class DataStore {

    // MARK: - Private Properties

    lazy var persistentContainer = NSPersistentContainer(name: "LastFM_Companion")
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Public Methods

    func prepare() {
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data could not be initialised. Error: \(error.localizedDescription)")
            }
        }
    }

    func fetch<LocalModel: CoreDataMappable, CoreDataModel: LocalMappable & NSManagedObject>(request: NSFetchRequest<CoreDataModel>) throws -> [LocalModel] {
        let items = try context.fetch(request)
        return items.compactMap({ $0.mapLocalModel() as? LocalModel })
    }

    func save<T: CoreDataMappable>(_ object: T) throws {
        object.mapDataModel(context: context)
        try context.save()
    }

    func delete<T: CoreDataMappable>(_ object: T) throws {
        let request = T.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", argumentArray: [object.id])
        let coreDataModel = (try context.fetch(request)).first

        guard let model = coreDataModel else {
            throw(CDError.fetchError)
        }
        
        context.delete(model)
        try context.save()
    }
}
