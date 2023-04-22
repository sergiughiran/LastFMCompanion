//
//  APIError.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 31.05.2021.
//

enum APIError: Int, Error {
    case undefined
    case invalidParameter = 6
    case operationFailed = 8
    case serviceOffline = 11
    case temporaryError = 16
    case suspendedApiKey = 26
    case excededRateLimit = 29

    var description: String {
        switch self {
        case .serviceOffline:
            return "This service is temporarily offline. Try again later."
        case .temporaryError:
            return "There was a temporary error processing your request. Please try again."
        case .suspendedApiKey:
            return "Access for your account has been suspended, please contact Last.fm"
        case .excededRateLimit:
            return "Your IP has made too many requests in a short period."
        default:
            return "We ran into a problem. Please try again."
        }
    }
}
