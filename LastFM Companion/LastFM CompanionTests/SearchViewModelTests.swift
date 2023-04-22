//
//  SearchViewModelTests.swift
//  LastFM CompanionTests
//
//  Created by Ghiran Sergiu on 17.06.2021.
//

import XCTest
@testable import LastFM_Companion

class SearchViewModelTests: XCTestCase {

    var sut: SearchViewModel!
    var searchServiceMock = SearchServiceMock()

    override func setUp() {
        sut = SearchViewModel(service: searchServiceMock)
    }

    func test_searchArtistSuccessfull() {
        let artist = "Artist"
        let mockedArtists = mockedArtists()

        let expectedResult: Result<Artists, APIError> = .success(mockedArtists)
        searchServiceMock.expectedResult = expectedResult

        let expectedArtists = mockedArtists.all
        var actualArtists = [Artist]()

        let expectation = self.expectation(description: "searchArtist")
        sut.searchArtist(artist) { result in
            if case let .success(artists) = result {
                actualArtists = artists
            } else {
                XCTFail()
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(actualArtists, expectedArtists)
        XCTAssertEqual(sut.resultType, .artist)
    }

    func test_searchArtistUndefinedError() {
        let artist = "Artist"
        let expectedResult: Result<Artists, APIError> = .failure(.undefined)
        searchServiceMock.expectedResult = expectedResult

        let expectedError = APIError.undefined
        var actualError = APIError.undefined

        let expectation = self.expectation(description: "searchArtist")
        sut.searchArtist(artist) { result in
            if case let .failure(error) = result {
                actualError = error
            } else {
                XCTFail()
            }

            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotEqual(sut.resultType, .artist)
    }

    func test_searchArtistInvalidParameterError() {
        let artist = "Artist"
        let expectedResult: Result<Artists, APIError> = .failure(.invalidParameter)
        searchServiceMock.expectedResult = expectedResult

        let expectedError = APIError.invalidParameter
        var actualError = APIError.undefined

        let expectation = self.expectation(description: "searchArtist")
        sut.searchArtist(artist) { result in
            if case let .failure(error) = result {
                actualError = error
            } else {
                XCTFail()
            }

            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotEqual(sut.resultType, .artist)
    }

    func test_searchArtistOperationFailedError() {
        let artist = "Artist"
        let expectedResult: Result<Artists, APIError> = .failure(.operationFailed)
        searchServiceMock.expectedResult = expectedResult

        let expectedError = APIError.operationFailed
        var actualError = APIError.undefined

        let expectation = self.expectation(description: "searchArtist")
        sut.searchArtist(artist) { result in
            if case let .failure(error) = result {
                actualError = error
            } else {
                XCTFail()
            }

            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotEqual(sut.resultType, .artist)
    }

    func test_searchArtistServiceOfflineError() {
        let artist = "Artist"
        let expectedResult: Result<Artists, APIError> = .failure(.serviceOffline)
        searchServiceMock.expectedResult = expectedResult

        let expectedError = APIError.serviceOffline
        var actualError = APIError.undefined

        let expectation = self.expectation(description: "searchArtist")
        sut.searchArtist(artist) { result in
            if case let .failure(error) = result {
                actualError = error
            } else {
                XCTFail()
            }

            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotEqual(sut.resultType, .artist)
    }

    func test_searchArtistTemporaryErrorError() {
        let artist = "Artist"
        let expectedResult: Result<Artists, APIError> = .failure(.temporaryError)
        searchServiceMock.expectedResult = expectedResult

        let expectedError = APIError.temporaryError
        var actualError = APIError.undefined

        let expectation = self.expectation(description: "searchArtist")
        sut.searchArtist(artist) { result in
            if case let .failure(error) = result {
                actualError = error
            } else {
                XCTFail()
            }

            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotEqual(sut.resultType, .artist)
    }

    func test_searchArtistSuspendedApiKeyError() {
        let artist = "Artist"
        let expectedResult: Result<Artists, APIError> = .failure(.suspendedApiKey)
        searchServiceMock.expectedResult = expectedResult

        let expectedError = APIError.suspendedApiKey
        var actualError = APIError.undefined

        let expectation = self.expectation(description: "searchArtist")
        sut.searchArtist(artist) { result in
            if case let .failure(error) = result {
                actualError = error
            } else {
                XCTFail()
            }

            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotEqual(sut.resultType, .artist)
    }

    func test_searchArtistExcededRateLimitError() {
        let artist = "Artist"
        let expectedResult: Result<Artists, APIError> = .failure(.excededRateLimit)
        searchServiceMock.expectedResult = expectedResult

        let expectedError = APIError.excededRateLimit
        var actualError = APIError.undefined

        let expectation = self.expectation(description: "searchArtist")
        sut.searchArtist(artist) { result in
            if case let .failure(error) = result {
                actualError = error
            } else {
                XCTFail()
            }

            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotEqual(sut.resultType, .artist)
    }

    func test_loadNextSuccessfull() {
        let artist = "Artist"
        let mockedArtists = mockedArtists(isSinglePage: false)

        let expectedResult: Result<Artists, APIError> = .success(mockedArtists)
        searchServiceMock.expectedResult = expectedResult

        var searchResults = mockedArtists.all
        searchResults.append(contentsOf: mockedArtists.all)

        let expectedArtists = searchResults
        var actualArtists = [Artist]()

        let expectation = self.expectation(description: "searchArtist")
        sut.searchArtist(artist) { result in
            switch result {
            case .success:
                self.sut.loadNextPage { result in
                    if case let .success(artists) = result {
                        actualArtists = artists
                    } else {
                        XCTFail()
                    }
                    
                    expectation.fulfill()
                }
            case .failure:
                XCTFail()
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(actualArtists, expectedArtists)
        XCTAssertEqual(sut.resultType, .artist)
    }

    func test_loadNextUndefinedError() {
        let artist = "Artist"
        let mockedArtists = mockedArtists(isSinglePage: false)

        var expectedResult: Result<Artists, APIError> = .success(mockedArtists)
        searchServiceMock.expectedResult = expectedResult

        let expectedError = APIError.undefined
        var actualError = APIError.undefined

        let expectation = self.expectation(description: "searchArtist")
        sut.searchArtist(artist) { result in
            switch result {
            case .success:
                expectedResult = .failure(.undefined)
                self.searchServiceMock.expectedResult = expectedResult
                self.sut.loadNextPage { result in
                    if case let .failure(error) = result {
                        actualError = error
                    } else {
                        XCTFail()
                    }
                    
                    expectation.fulfill()
                }
            case .failure:
                XCTFail()
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(actualError, expectedError)
    }

    func test_loadNextInvalidParameterError() {
        let artist = "Artist"
        let mockedArtists = mockedArtists(isSinglePage: false)

        var expectedResult: Result<Artists, APIError> = .success(mockedArtists)
        searchServiceMock.expectedResult = expectedResult

        let expectedError = APIError.invalidParameter
        var actualError = APIError.undefined

        let expectation = self.expectation(description: "searchArtist")
        sut.searchArtist(artist) { result in
            switch result {
            case .success:
                expectedResult = .failure(.invalidParameter)
                self.searchServiceMock.expectedResult = expectedResult
                self.sut.loadNextPage { result in
                    if case let .failure(error) = result {
                        actualError = error
                    } else {
                        XCTFail()
                    }
                    
                    expectation.fulfill()
                }
            case .failure:
                XCTFail()
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(actualError, expectedError)
    }

    func test_loadNextOperationFailedError() {
        let artist = "Artist"
        let mockedArtists = mockedArtists(isSinglePage: false)

        var expectedResult: Result<Artists, APIError> = .success(mockedArtists)
        searchServiceMock.expectedResult = expectedResult

        let expectedError = APIError.operationFailed
        var actualError = APIError.undefined

        let expectation = self.expectation(description: "searchArtist")
        sut.searchArtist(artist) { result in
            switch result {
            case .success:
                expectedResult = .failure(.operationFailed)
                self.searchServiceMock.expectedResult = expectedResult
                self.sut.loadNextPage { result in
                    if case let .failure(error) = result {
                        actualError = error
                    } else {
                        XCTFail()
                    }
                    
                    expectation.fulfill()
                }
            case .failure:
                XCTFail()
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(actualError, expectedError)
    }

    func test_loadNextServiceOfflineError() {
        let artist = "Artist"
        let mockedArtists = mockedArtists(isSinglePage: false)

        var expectedResult: Result<Artists, APIError> = .success(mockedArtists)
        searchServiceMock.expectedResult = expectedResult

        let expectedError = APIError.serviceOffline
        var actualError = APIError.undefined

        let expectation = self.expectation(description: "searchArtist")
        sut.searchArtist(artist) { result in
            switch result {
            case .success:
                expectedResult = .failure(.serviceOffline)
                self.searchServiceMock.expectedResult = expectedResult
                self.sut.loadNextPage { result in
                    if case let .failure(error) = result {
                        actualError = error
                    } else {
                        XCTFail()
                    }
                    
                    expectation.fulfill()
                }
            case .failure:
                XCTFail()
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(actualError, expectedError)
    }

    func test_loadNextTemporaryErrorError() {
        let artist = "Artist"
        let mockedArtists = mockedArtists(isSinglePage: false)

        var expectedResult: Result<Artists, APIError> = .success(mockedArtists)
        searchServiceMock.expectedResult = expectedResult

        let expectedError = APIError.temporaryError
        var actualError = APIError.undefined

        let expectation = self.expectation(description: "searchArtist")
        sut.searchArtist(artist) { result in
            switch result {
            case .success:
                expectedResult = .failure(.temporaryError)
                self.searchServiceMock.expectedResult = expectedResult
                self.sut.loadNextPage { result in
                    if case let .failure(error) = result {
                        actualError = error
                    } else {
                        XCTFail()
                    }
                    
                    expectation.fulfill()
                }
            case .failure:
                XCTFail()
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(actualError, expectedError)
    }

    func test_loadNextSuspendedApiKeyError() {
        let artist = "Artist"
        let mockedArtists = mockedArtists(isSinglePage: false)

        var expectedResult: Result<Artists, APIError> = .success(mockedArtists)
        searchServiceMock.expectedResult = expectedResult

        let expectedError = APIError.suspendedApiKey
        var actualError = APIError.undefined

        let expectation = self.expectation(description: "searchArtist")
        sut.searchArtist(artist) { result in
            switch result {
            case .success:
                expectedResult = .failure(.suspendedApiKey)
                self.searchServiceMock.expectedResult = expectedResult
                self.sut.loadNextPage { result in
                    if case let .failure(error) = result {
                        actualError = error
                    } else {
                        XCTFail()
                    }
                    
                    expectation.fulfill()
                }
            case .failure:
                XCTFail()
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(actualError, expectedError)
    }

    func test_loadNextExcededRateLimitError() {
        let artist = "Artist"
        let mockedArtists = mockedArtists(isSinglePage: false)

        var expectedResult: Result<Artists, APIError> = .success(mockedArtists)
        searchServiceMock.expectedResult = expectedResult

        let expectedError = APIError.excededRateLimit
        var actualError = APIError.undefined

        let expectation = self.expectation(description: "searchArtist")
        sut.searchArtist(artist) { result in
            switch result {
            case .success:
                expectedResult = .failure(.excededRateLimit)
                self.searchServiceMock.expectedResult = expectedResult
                self.sut.loadNextPage { result in
                    if case let .failure(error) = result {
                        actualError = error
                    } else {
                        XCTFail()
                    }
                    
                    expectation.fulfill()
                }
            case .failure:
                XCTFail()
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(actualError, expectedError)
    }

    private func mockedArtists(isSinglePage: Bool = true) -> Artists {
        let firstArtist = Artist(name: "First", listeners: "1", imageURL: nil)
        let secondArtist = Artist(name: "Second", listeners: "2", imageURL: nil)

        return Artists(all: [firstArtist, secondArtist], totalCount: isSinglePage ? "2" : "4")
    }
}
