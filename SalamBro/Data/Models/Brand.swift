//
//  Brand.swift
//  SalamBro
//
//  Created by Arystan on 4/7/21.
//

import Foundation

class Brand: Codable {
    let id: Int?
    let name: String
    let image: String?
    var isAvailable: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case isAvailable = "is_available"
    }

    init(id: Int?, name: String, image: String?, isAvailable: Bool) {
        self.id = id
        self.name = name
        self.image = image
        self.isAvailable = isAvailable
    }
}

extension Brand {
    func getCopy() -> Brand {
        return .init(id: id, name: name, image: image, isAvailable: isAvailable ?? false)
    }
}

extension Brand: Equatable {
    static func == (lhs: Brand, rhs: Brand) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}
