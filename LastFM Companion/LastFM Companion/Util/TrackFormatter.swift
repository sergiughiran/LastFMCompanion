//
//  TrackFormatter.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 12.06.2021.
//

import Foundation

struct TrackFormatter {
    /**
     Formats a track's duration with the standard `mm:ss` format.
     
     - Parameters:
        - duration: The track duration
     
     - Returns: The formatted duration
     */
    static func formattedDuration(_ duration: Int) -> String {
        let (minutes, seconds) = duration.quotientAndRemainder(dividingBy: 60)
    
        let minutesString = minutes < 10 ? "0\(minutes)" : String(minutes)
        let secondsString = seconds < 10 ? "0\(seconds)" : String(seconds)
        
        return minutesString + ":" + secondsString
    }

    /**
     Formats a track's rank by adding a `0` as a prefix in case the value is smaller than 10.
     
     - Parameters:
        - rank: The track rank
     
     - Returns: The formatted rank
     */
    static func formattedRank(_ rank: String) -> String {
        guard let rankNo = Int(rank) else { return "" }
        return rankNo < 10 ? "0\(rankNo)" : rank
    }
}
