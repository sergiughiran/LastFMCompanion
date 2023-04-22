//
//  CollectionViewDataSource.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 10.06.2021.
//

import UIKit

final class CollectionViewDataSource<Model>: NSObject, UICollectionViewDataSource {
    typealias CellConfigurator = (Model, UICollectionViewCell) -> Void
    typealias HeaderConfigurator = (Int, UICollectionReusableView) -> Void

    // MARK: - Public Properties

    var model: [Model]

    // MARK: - Private Properties

    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator

    private var headerReuseIdentifier: String?
    private var headerConfigurator: HeaderConfigurator?

    // MARK: - Lifecycle

    /**
     Initializes a new generic Data Source for any `UICollectionView`. The header specified here will be used only if both `headerReuseIdentifier` and `headerConfigurator` are set.
     
     - Parameters:
        - model: The data array that should be displayed in the UICollectionView
        - reuseIdentifier: The cell reuse identifier
        - cellConfigurator: The closure resposible with setting up each cell
        - headerReuseIdentifier: The header reuse identifier
        - headerConfigurator: The closure resposible with setting up the section header
     
     - Returns: The configured wrapper ready to be set as the `dataSource` of your `UICollectionView`
     */
    init(model: [Model] = [], reuseIdentifier: String, cellConfigurator: @escaping CellConfigurator, headerReuseIdentifier: String? = nil, headerConfigurator: HeaderConfigurator? = nil) {
        self.model = model

        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator

        self.headerReuseIdentifier = headerReuseIdentifier
        self.headerConfigurator = headerConfigurator
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !model.isEmpty else {
            let emptyView = CollectionEmptyView(location: .library)

            emptyView.frame = collectionView.bounds
            collectionView.backgroundView = emptyView

            return 0
        }

        collectionView.backgroundView = nil
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cellConfigurator(model[indexPath.item], cell)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerReuseIdentifier = headerReuseIdentifier, let headerConfigurator = headerConfigurator else { return UICollectionReusableView() }

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath)
        headerConfigurator(indexPath.section, headerView)

        return headerView
    }
}
