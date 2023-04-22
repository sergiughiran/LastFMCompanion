//
//  TrackTableViewCell.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 11.06.2021.
//

import UIKit
import AlamofireImage

final class TrackTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak var trackNoLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var trackDurationLabel: UILabel!

    // MARK: - Lifecycle

    func setup(with track: Track) {
        trackNoLabel.text = TrackFormatter.formattedRank(track.rank)
        trackNameLabel.text = track.name
        artistNameLabel.text = track.artist
        trackDurationLabel.text = TrackFormatter.formattedDuration(track.duration)
    }
}
