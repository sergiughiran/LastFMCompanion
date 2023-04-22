//
//  ArtistViewModelTests.swift
//  LastFM CompanionTests
//
//  Created by Ghiran Sergiu on 18.06.2021.
//

import XCTest
@testable import LastFM_Companion

class ArtistViewModelTests: XCTestCase {
    var sut: ArtistViewModel!
    var artistMock: Artist = Artist(name: "Artist", listeners: "100", imageURL: nil)
    var artistServiceMock = ArtistServiceMock()
    var albumServiceMock = AlbumServiceMock()

    override func setUp() {
        sut = ArtistViewModel(artist: artistMock, artistService: artistServiceMock, albumService: albumServiceMock, localAlbums: LocalAlbums())
    }

    func test_loadDataSuccess() {
        let mockedAlbums = mockTopAlbums()
        let expectedResult: Result<TopAlbums, APIError> = .success(mockedAlbums)

        artistServiceMock.expectedResult = expectedResult

        var actualAlbums: [Album]?

        let expectation = expectation(description: "artistLoadDataSuccess")
        sut.getTopAlbums { result in
            if case let .success(albums) = result {
                actualAlbums = albums
            } else {
                XCTFail("Artist get call should not fail.")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(actualAlbums, "Response albums should not be nil")
        XCTAssertEqual(mockedAlbums.all, actualAlbums)
    }

    func test_loadDataUndefinedError() {
        let expectedError = APIError.undefined
        let expectedResult: Result<TopAlbums, APIError> = .failure(expectedError)
        artistServiceMock.expectedResult = expectedResult

        var actualError: APIError?

        let expectation = expectation(description: "artistLoadDataUndefinedError")
        sut.getTopAlbums { result in
            if case let .failure(error) = result {
                actualError = error
            } else {
                XCTFail("Artist get call should not succeed.")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(actualError, "Response error should not be nil")
        XCTAssertEqual(expectedError, actualError)
    }

    func test_loadDataInvalidParameterError() {
        let expectedError = APIError.invalidParameter
        let expectedResult: Result<TopAlbums, APIError> = .failure(expectedError)
        artistServiceMock.expectedResult = expectedResult

        var actualError: APIError?

        let expectation = expectation(description: "artistLoadDataInvalidParameterError")
        sut.getTopAlbums { result in
            if case let .failure(error) = result {
                actualError = error
            } else {
                XCTFail("Artist get call should not succeed.")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(actualError, "Response error should not be nil")
        XCTAssertEqual(expectedError, actualError)
    }

    func test_loadDataOperationFailedError() {
        let expectedError = APIError.operationFailed
        let expectedResult: Result<TopAlbums, APIError> = .failure(expectedError)
        artistServiceMock.expectedResult = expectedResult

        var actualError: APIError?

        let expectation = expectation(description: "artistLoadDataOperationFailedError")
        sut.getTopAlbums { result in
            if case let .failure(error) = result {
                actualError = error
            } else {
                XCTFail("Artist get call should not succeed.")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(actualError, "Response error should not be nil")
        XCTAssertEqual(expectedError, actualError)
    }

    func test_loadDataServiceOfflineError() {
        let expectedError = APIError.serviceOffline
        let expectedResult: Result<TopAlbums, APIError> = .failure(expectedError)
        artistServiceMock.expectedResult = expectedResult

        var actualError: APIError?

        let expectation = expectation(description: "artistLoadDataServiceOfflineError")
        sut.getTopAlbums { result in
            if case let .failure(error) = result {
                actualError = error
            } else {
                XCTFail("Artist get call should not succeed.")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(actualError, "Response error should not be nil")
        XCTAssertEqual(expectedError, actualError)
    }

    func test_loadDataTemporaryErrorError() {
        let expectedError = APIError.temporaryError
        let expectedResult: Result<TopAlbums, APIError> = .failure(expectedError)
        artistServiceMock.expectedResult = expectedResult

        var actualError: APIError?

        let expectation = expectation(description: "artistLoadDataTemporaryErrorError")
        sut.getTopAlbums { result in
            if case let .failure(error) = result {
                actualError = error
            } else {
                XCTFail("Artist get call should not succeed.")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(actualError, "Response error should not be nil")
        XCTAssertEqual(expectedError, actualError)
    }

    func test_loadDataSuspendedApiKeyError() {
        let expectedError = APIError.suspendedApiKey
        let expectedResult: Result<TopAlbums, APIError> = .failure(expectedError)
        artistServiceMock.expectedResult = expectedResult

        var actualError: APIError?

        let expectation = expectation(description: "artistLoadDataSuspendedApiKeyError")
        sut.getTopAlbums { result in
            if case let .failure(error) = result {
                actualError = error
            } else {
                XCTFail("Artist get call should not succeed.")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(actualError, "Response error should not be nil")
        XCTAssertEqual(expectedError, actualError)
    }

    func test_loadDataExcededRateLimitError() {
        let expectedError = APIError.excededRateLimit
        let expectedResult: Result<TopAlbums, APIError> = .failure(expectedError)
        artistServiceMock.expectedResult = expectedResult

        var actualError: APIError?

        let expectation = expectation(description: "artistLoadDataExcededRateLimitError")
        sut.getTopAlbums { result in
            if case let .failure(error) = result {
                actualError = error
            } else {
                XCTFail("Artist get call should not succeed.")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(actualError, "Response error should not be nil")
        XCTAssertEqual(expectedError, actualError)
    }

    private func mockTopAlbums() -> TopAlbums {
        let firstAlbum = Album(
            id: "OneOne",
            name: "One",
            artist: "One",
            imageURL: "",
            tracks: [],
            description: "The first album",
            image: nil
        )

        let secondAlbum = Album(
            id: "TwoTwo",
            name: "Two",
            artist: "Two",
            imageURL: "",
            tracks: [],
            description: "The second album",
            image: nil
        )

        return TopAlbums(all: [firstAlbum, secondAlbum])
    }
}
