//
//  CDError.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 16.06.2021.
//

enum CDError: Error {
    case fetchError
    case saveError
    case removeError

    var description: String {
        switch self {
        case .fetchError:
            return "There was an error fetching your local albums. Please try again."
        case .saveError:
            return "There was a problem saving this album. Please try another one."
        case .removeError:
            return "There was a problem removing this album. Please try again."
        }
    }
}
