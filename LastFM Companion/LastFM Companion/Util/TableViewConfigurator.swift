//
//  TableViewConfigurator.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 12.06.2021.
//

import UIKit

final class TableViewConfigurator<Model>: NSObject, UITableViewDataSource, UITableViewDelegate {
    typealias CellConfigurator = (Model, UITableViewCell) -> Void
    typealias CellActionConfigurator = (Model) -> Void
    typealias HeaderViewConfigurator = (Int, UITableViewHeaderFooterView) -> Void
    typealias DeleteHandler = (Int) -> Void

    // MARK: - Public Properties

    var model: [Model]

    // MARK: - Private Properties

    private var isDeleteEnabled: Bool
    private var deleteHandler: DeleteHandler?

    private var cellReuseIdentifier: String
    private var cellConfigurator: CellConfigurator
    private var cellActionConfigurator: CellActionConfigurator?

    private var headerReuseIdentifier: String?
    private var headerViewConfigurator: HeaderViewConfigurator?

    private var emptyListLocation: CollectionEmptyView.Location

    // MARK: - Lifecycle

    /**
     Initialises a configurator that can act as both the `dataSource` and the `delegate` for the `UITableView` instance. The delegate functionality is enabled by setting the `cellActionConfigurator` property.
     
     - Parameters:
        - model: The model used to display the table view cells
        - cellReuseIdentifier: The `UITableViewCell` reuse identifier
        - cellConfigurator: The closure responsible for setting up the cell
        - cellActionConfigurator: The closure responsible for handling `UITableViewCell` tap events
        - headerReuseIdentifier: The `UITableHeaderFooterView` reuse identifier
        - headerViewConfigurator: The closure responsible for setting up the section header
        - isDeleteEnabled: Flag specifying if the cells are delete enabled
        - deleteHandler: The closure responsible with handling delete actions
        - emptyListLocation: Enum responsible for setting up an empty view in case there are no model values
     
     - Returns: The `UITableView` configurator.
     */
    init(model: [Model] = [], cellReuseIdentifier: String, cellConfigurator: @escaping CellConfigurator, cellActionConfigurator: CellActionConfigurator? = nil, headerReuseIdentifier: String? = nil, headerViewConfigurator: HeaderViewConfigurator? = nil, isDeleteEnabled: Bool = false, deleteHandler: DeleteHandler? = nil, emptyListLocation: CollectionEmptyView.Location) {
        self.model = model

        self.cellReuseIdentifier = cellReuseIdentifier
        self.cellConfigurator = cellConfigurator
        self.cellActionConfigurator = cellActionConfigurator

        self.headerReuseIdentifier = headerReuseIdentifier
        self.headerViewConfigurator = headerViewConfigurator

        self.isDeleteEnabled = isDeleteEnabled
        self.deleteHandler = deleteHandler

        self.emptyListLocation = emptyListLocation
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !model.isEmpty else {
            let emptyView = CollectionEmptyView(location: emptyListLocation)

            // We check to see if we have a tableHeaderView set and, if so, we set the empty view frame so that it's centered on the list area only.
            var tableViewFrame = tableView.bounds
            if let headerView = tableView.tableHeaderView {
                tableViewFrame = CGRect(x: 0, y: headerView.frame.height, width: tableView.bounds.width, height: tableView.bounds.height - headerView.frame.height)
            }

            emptyView.frame = tableViewFrame

            tableView.backgroundView = UIView()
            tableView.backgroundView?.addSubview(emptyView)
            tableView.isScrollEnabled = false

            return 0
        }

        tableView.isScrollEnabled = true
        tableView.backgroundView = nil
        return model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cellConfigurator(model[indexPath.row], cell)

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerReuseIdentifier = headerReuseIdentifier,
              let headerViewConfigurator = headerViewConfigurator,
              let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier)
        else { return nil }

        headerViewConfigurator(section, headerView)
        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellActionConfigurator?(model[indexPath.row])
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isDeleteEnabled
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard isDeleteEnabled else { return }

        if editingStyle == .delete {
            deleteHandler?(indexPath.row)

            model.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
