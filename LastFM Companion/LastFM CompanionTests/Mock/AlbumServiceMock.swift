//
//  AlbumServiceMock.swift
//  LastFM CompanionTests
//
//  Created by Ghiran Sergiu on 17.06.2021.
//

import XCTest
@testable import LastFM_Companion

final class AlbumServiceMock: AlbumService {

    var apiExpectedResult: Result<AlbumContainer, APIError>?
    
    override func getAlbumDetails(_ album: String, artist: String, completion: @escaping (Result<AlbumContainer, APIError>) -> Void) {
        guard let apiExpectedResult = apiExpectedResult else {
            XCTFail()
            return
        }

        completion(apiExpectedResult)
    }
}
