//
//  ArtistServiceMock.swift
//  LastFM CompanionTests
//
//  Created by Ghiran Sergiu on 17.06.2021.
//

import XCTest
@testable import LastFM_Companion

final class ArtistServiceMock: ArtistService {

    var expectedResult: Result<TopAlbums, APIError>?

    override func getTopAlbums(of artist: String, completion: @escaping (Result<TopAlbums, APIError>) -> Void) {
        guard let expectedResult = expectedResult else {
            XCTFail()
            return
        }

        completion(expectedResult)
    }
}
