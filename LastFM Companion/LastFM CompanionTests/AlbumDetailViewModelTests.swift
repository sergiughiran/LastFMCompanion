//
//  AlbumDetailViewModelTests.swift
//  LastFM CompanionTests
//
//  Created by Ghiran Sergiu on 18.06.2021.
//

import XCTest
@testable import LastFM_Companion

class AlbumDetailViewModelTests: XCTestCase {

    var remoteSut: AlbumDetailViewModel!
    var localSut: AlbumDetailViewModel!
    var albumMock: Album!
    var mockDataStore: DataStoreMock!
    var mockService: AlbumServiceMock!
    var localAlbums = LocalAlbums()

    override func setUp() {
        mockDataStore = DataStoreMock()
        mockService = AlbumServiceMock(dataStore: mockDataStore, localAlbums: localAlbums)
        let _ = mockService.getAlbums()

        mockDataStore.prepare()

        albumMock = Album(id: "AlbumArtist", name: "Album", artist: "Artist", imageURL: "", tracks: [], description: "The album", image: nil)
        remoteSut = AlbumDetailViewModel(topAlbum: albumMock, service: mockService, localAlbums: LocalAlbums())
        localSut = AlbumDetailViewModel(album: albumMock, service: mockService, localAlbums: localAlbums)

        let preSavedAlbum = Album(id: "ArtistAlbum", name: "Album", artist: "Artist", imageURL: "", tracks: [], description: "The album", image: nil)
        mockService.saveAlbum(preSavedAlbum)
    }

    func test_loadDataFromRemoteSuccess() {
        let mockAlbum = mockAlbum()
        let expectedResult: Result<AlbumContainer, APIError> = .success(mockAlbum)
        mockService.apiExpectedResult = expectedResult

        var responseAlbum: Album?
        let expectation = expectation(description: "albumLoadDataSuccess")
        remoteSut.getAlbumDetails { result in
            if case let .success(album) = result {
                responseAlbum = album
            } else {
                XCTFail("Album response shouldn't fail")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(responseAlbum, "Result should not be nil")
        XCTAssertEqual(mockAlbum.album, responseAlbum)
        XCTAssertEqual(remoteSut.album, mockAlbum.album)
    }

    func test_loadDataFromLocalSuccess() {
        var responseAlbum: Album?
        let expectation = expectation(description: "albumLoadDataLocalSuccess")
        localSut.getAlbumDetails { result in
            if case let .success(album) = result {
                responseAlbum = album
            } else {
                XCTFail("Album response shouldn't fail")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(responseAlbum, "Result should not be nil")
        XCTAssertEqual(albumMock, responseAlbum)
    }

    func test_loadDataUndefinedError() {
        let expectedError = APIError.undefined
        let expectedResult: Result<AlbumContainer, APIError> = .failure(expectedError)
        mockService.apiExpectedResult = expectedResult

        var responseError: APIError?
        let expectation = expectation(description: "albumLoadDataUndefinedError")
        remoteSut.getAlbumDetails { result in
            if case let .failure(error) = result {
                responseError = error
            } else {
                XCTFail("Album response shouldn't succeed")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(responseError, "Error should not be nil")
        XCTAssertEqual(expectedError, responseError)
        XCTAssertNil(remoteSut.album)
    }

    func test_loadDataInvalidParameterError() {
        let expectedError = APIError.invalidParameter
        let expectedResult: Result<AlbumContainer, APIError> = .failure(expectedError)
        mockService.apiExpectedResult = expectedResult

        var responseError: APIError?
        let expectation = expectation(description: "albumLoadDataInvalidParameterError")
        remoteSut.getAlbumDetails { result in
            if case let .failure(error) = result {
                responseError = error
            } else {
                XCTFail("Album response shouldn't succeed")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(responseError, "Error should not be nil")
        XCTAssertEqual(expectedError, responseError)
        XCTAssertNil(remoteSut.album)
    }

    func test_loadDataOperationFailedError() {
        let expectedError = APIError.operationFailed
        let expectedResult: Result<AlbumContainer, APIError> = .failure(expectedError)
        mockService.apiExpectedResult = expectedResult

        var responseError: APIError?
        let expectation = expectation(description: "albumLoadDataOperationFailedError")
        remoteSut.getAlbumDetails { result in
            if case let .failure(error) = result {
                responseError = error
            } else {
                XCTFail("Album response shouldn't succeed")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(responseError, "Error should not be nil")
        XCTAssertEqual(expectedError, responseError)
        XCTAssertNil(remoteSut.album)
    }

    func test_loadDataServiceOfflineError() {
        let expectedError = APIError.serviceOffline
        let expectedResult: Result<AlbumContainer, APIError> = .failure(expectedError)
        mockService.apiExpectedResult = expectedResult

        var responseError: APIError?
        let expectation = expectation(description: "albumLoadDataServiceOfflineError")
        remoteSut.getAlbumDetails { result in
            if case let .failure(error) = result {
                responseError = error
            } else {
                XCTFail("Album response shouldn't succeed")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(responseError, "Error should not be nil")
        XCTAssertEqual(expectedError, responseError)
        XCTAssertNil(remoteSut.album)
    }

    func test_loadDataTemporaryErrorError() {
        let expectedError = APIError.temporaryError
        let expectedResult: Result<AlbumContainer, APIError> = .failure(expectedError)
        mockService.apiExpectedResult = expectedResult

        var responseError: APIError?
        let expectation = expectation(description: "albumLoadDataTemporaryErrorError")
        remoteSut.getAlbumDetails { result in
            if case let .failure(error) = result {
                responseError = error
            } else {
                XCTFail("Album response shouldn't succeed")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(responseError, "Error should not be nil")
        XCTAssertEqual(expectedError, responseError)
        XCTAssertNil(remoteSut.album)
    }

    func test_loadDataSuspendedApiKeyError() {
        let expectedError = APIError.suspendedApiKey
        let expectedResult: Result<AlbumContainer, APIError> = .failure(expectedError)
        mockService.apiExpectedResult = expectedResult

        var responseError: APIError?
        let expectation = expectation(description: "albumLoadDataSuspendedApiKeyError")
        remoteSut.getAlbumDetails { result in
            if case let .failure(error) = result {
                responseError = error
            } else {
                XCTFail("Album response shouldn't succeed")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(responseError, "Error should not be nil")
        XCTAssertEqual(expectedError, responseError)
        XCTAssertNil(remoteSut.album)
    }

    func test_loadDataExcededRateLimitError() {
        let expectedError = APIError.excededRateLimit
        let expectedResult: Result<AlbumContainer, APIError> = .failure(expectedError)
        mockService.apiExpectedResult = expectedResult

        var responseError: APIError?
        let expectation = expectation(description: "albumLoadDataExcededRateLimitError")
        remoteSut.getAlbumDetails { result in
            if case let .failure(error) = result {
                responseError = error
            } else {
                XCTFail("Album response shouldn't succeed")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(responseError, "Error should not be nil")
        XCTAssertEqual(expectedError, responseError)
        XCTAssertNil(remoteSut.album)
    }

    func test_removeSuccess() {
        mockService.saveAlbum(albumMock)

        var isSaved: Bool?

        let expectation = expectation(description: "saveSuccess")
        localSut.handleSave { result in
            if case let .success(isSavedResult) = result {
                isSaved = isSavedResult
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(isSaved, "isSaved should not be nil")
        XCTAssertFalse(isSaved!)
        XCTAssertEqual(isSaved, localSut.isSaved)
    }

    func test_saveSuccess() {
        var isSaved: Bool?

        let expectation = expectation(description: "removeSuccess")
        localSut.handleSave { result in
            if case let .success(result) = result {
                isSaved = result
            } else {
                XCTFail("Save should not fail")
            }
            
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(isSaved, "isSaved should not be nil")
        XCTAssertTrue(isSaved!)
        XCTAssertEqual(isSaved, localSut.isSaved)
    }

    private func mockAlbum() -> AlbumContainer {
        return AlbumContainer(album: Album(id: "AlbumArtist", name: "Album", artist: "Artist", imageURL: "", tracks: [], description: "The album", image: nil))
    }
}
