//
//  Brand.swift
//  SalamBro
//
//  Created by Arystan on 4/7/21.
//

import Foundation

struct Brand: Codable {
    let id: Int
    let name: String
    let images: BrandImage
    let isAvailable: Bool

    struct BrandImage: Codable {
        let imageSquare: String
        let imageShort: String
        let imageTall: String
        let imageLong: String

        enum CodingKeys: String, CodingKey {
            case imageSquare = "image_square"
            case imageShort = "image_short"
            case imageTall = "image_tall"
            case imageLong = "image_long"
        }
    }
}

extension Brand: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}
