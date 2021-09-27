//
//  Brand.swift
//  SalamBro
//
//  Created by Arystan on 4/7/21.
//

import Foundation

class Brand: Codable {
    let id: Int
    let name: String
    let imageSmall: String?
    let imageBig: String?
    var isAvailable: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageSmall = "image_small"
        case imageBig = "image_big"
        case isAvailable = "is_available"
    }

    init(id: Int, name: String, imageSmall: String?, imageBig: String?, isAvailable: Bool) {
        self.id = id
        self.name = name
        self.imageSmall = imageSmall
        self.imageBig = imageBig
        self.isAvailable = isAvailable
    }
}

extension Brand {
    func getCopy() -> Brand {
        return .init(id: id, name: name, imageSmall: imageSmall, imageBig: imageBig,
                     isAvailable: isAvailable ?? false)
    }
}

extension Brand: Equatable {
    static func == (lhs: Brand, rhs: Brand) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}
