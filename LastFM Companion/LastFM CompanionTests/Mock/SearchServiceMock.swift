//
//  SearchServiceMock.swift
//  LastFM CompanionTests
//
//  Created by Ghiran Sergiu on 17.06.2021.
//

import XCTest
@testable import LastFM_Companion

final class SearchServiceMock: SearchService {

    var expectedResult: Result<Artists, APIError>?

    override func searchArtist(_ artist: String, page: Int, limit: Int, completion: @escaping (Result<Artists, APIError>) -> Void) {
        guard let expectedResult = expectedResult else {
            XCTFail()
            return
        }

        completion(expectedResult)
    }

    
}
