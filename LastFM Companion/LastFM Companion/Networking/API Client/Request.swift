//
//  Request.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 30.05.2021.
//

import Alamofire

private enum Constants {
    enum Parameters {
        static let apiKey = "api_key"
        static let format = "format"
    }

    static let baseURL = "https://ws.audioscrobbler.com/2.0/"
    static let apiKey = "aebc7262166614d874db0764ce9396b9"
    static let format = "json"
}

private enum Endpoints {
    enum Artist {
        static let search = "artist.search"
        static let info = "artist.getInfo"
        static let topAlbums = "artist.gettopalbums"
    }

    enum Album {
        static let info = "album.getInfo"
    }
}

/// Object responsible for a easier and more abstract API request creation
struct Request {
    private var method: HTTPMethod
    private var parameters: [String: String]
}

extension Request: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: URL(string: Constants.baseURL)!)
        request.method = method

        var parameters = self.parameters
        parameters[Constants.Parameters.apiKey] = Constants.apiKey
        parameters[Constants.Parameters.format] = Constants.format
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)

        return request
    }
}

extension Request {
    /**
     Initializes a search artist  `GET` request with paging enabled.
     
     - Parameters:
        - artist: The artist search criteria
        - page: The page to be requested
        - limit: The limit for elements per page
     
     - Returns: The configured request.
     */
    static func searchArtist(_ artist: String, at page: Int, limit: Int) -> Request {
        return Request(method: .get, parameters: [
            "method": Endpoints.Artist.search,
            "artist": artist,
            "page": String(page),
            "limit": String(limit)
        ])
    }

    /**
     Initializes an album  `GET` request.
     
     - Parameters:
        - album: The album name
        - artist: The artist name.
     
     - Returns: The configured request.
     */
    static func getAlbum(_ album: String, artist: String) -> Request {
        return Request(method: .get, parameters: [
            "method": Endpoints.Album.info,
            "album": album,
            "artist": artist
        ])
    }

    /**
     Initializes an artist  `GET` request.
     
     - Parameters:
        - artist: The artist name.
     
     - Returns: The configured request.
     */
    static func getArtistInfo(_ artist: String) -> Request {
        return Request(method: .get, parameters: [
            "method": Endpoints.Artist.info,
            "artist": artist
        ])
    }

    /**
     Initializes a top album  `GET` request to retrieve all of the top albums of the specified `artist`.
     
     - Parameters:
        - artist: The artist name.
     
     - Returns: The configured request.
     */
    static func getTopAlbums(of artist: String) -> Request {
        return Request(method: .get, parameters: [
            "method": Endpoints.Artist.topAlbums,
            "artist": artist
        ])
    }
}
