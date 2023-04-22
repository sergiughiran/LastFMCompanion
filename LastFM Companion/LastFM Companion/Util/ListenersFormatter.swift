//
//  ListenersFormatter.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 11.06.2021.
//

import Foundation

struct ListenersFormatter {

    // MARK: - Step

    private enum Step {
        case thousand
        case million

        var dividingFactor: Int {
            switch self {
            case .thousand:
                return 1000
            case .million:
                return 1000000
            }
        }

        var suffix: String {
            switch self {
            case .thousand:
                return "k"
            case .million:
                return "m"
            }
        }
    }

    // MARK: - Public Methods

    /**
     Formats the value as a shorthand version of itself by using `thousands` and `millions` as steps and by using either `k` or `m` as a suffix in case the value is in the appropriate ranges.
     
     - Parameters:
        - value: The value to be formatted
     
     - Returns: The formatted value
     */
    static func formattedValue(_ value: Int) -> String {
        if value > Step.million.dividingFactor {
            return "\(value / Step.million.dividingFactor)\(Step.million.suffix) listeners"
        } else if value > Step.thousand.dividingFactor {
            return "\(value / Step.thousand.dividingFactor)\(Step.thousand.suffix) listeners"
        } else {
            return "\(value) listeners"
        }
    }
    
}
