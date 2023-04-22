//
//  LibraryViewModelTests.swift
//  LastFM CompanionTests
//
//  Created by Ghiran Sergiu on 17.06.2021.
//

import XCTest
@testable import LastFM_Companion

class LibraryViewModelTests: XCTestCase {

    var sut: LibraryViewModel!
    var dataStoreMock: DataStoreMock!
    var albumServiceMock: AlbumServiceMock!

    override func setUp() {
        dataStoreMock = DataStoreMock()
        dataStoreMock.prepare()

        albumServiceMock = AlbumServiceMock(dataStore: dataStoreMock)
        sut = LibraryViewModel(service: albumServiceMock)
    }

    func test_loadData() {
        let mockedAlbums = mockModels()
        mockedAlbums.forEach({ albumServiceMock.saveAlbum($0) })

        let expectation = expectation(description: "loadDataSuccess")
        var fetchedAlbums: [Album]? = nil

        sut.loadData { result in
            if case let .success(albums) = result {
                fetchedAlbums = albums
            } else {
                XCTFail("Album fetch should not fail")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(fetchedAlbums, "Fetched albums should not be nil")
        XCTAssertEqual(fetchedAlbums, orderedAlbums(mockedAlbums))
    }

    private func mockModels() -> [Album] {
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

        return [firstAlbum, secondAlbum]
    }

    private func orderedAlbums(_ albums: [Album]) -> [Album] {
        return albums.sorted(by: {
            $0.artist != $1.artist ? $0.artist < $1.artist : $0.name < $1.name
        })
    }
}
