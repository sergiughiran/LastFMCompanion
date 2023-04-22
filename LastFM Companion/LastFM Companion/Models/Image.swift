//
//  Image.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 31.05.2021.
//

enum ImageSize: String, Decodable {
    case small
    case medium
    case large
    case extralarge
    case mega
    case original = ""
}

struct Image: Decodable {
    let urlString: String
    let size: ImageSize

    enum CodingKeys: String, CodingKey {
        case urlString = "#text"
        case size
    }
}
