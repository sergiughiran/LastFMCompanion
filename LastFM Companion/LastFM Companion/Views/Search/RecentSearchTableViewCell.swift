//
//  RecentSearchTableViewCell.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 05.06.2021.
//

import UIKit

final class RecentSearchTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    private var searchString: String?

    // MARK: - Outlets

    @IBOutlet weak var searchStringLabel: UILabel!

    // MARK: - Public Methods

    func setup(with model: String) {
        searchString = model
        searchStringLabel.text = model
    }
}
