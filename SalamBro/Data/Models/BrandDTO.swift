//
//  Brand.swift
//  SalamBro
//
//  Created by Arystan on 4/7/21.
//

import Foundation

public struct BrandDTO: Decodable {
    public let id: Int
    public var name: String
    public let priority: Int
}

public extension BrandDTO {
    func toDomain() -> Brand {
        .init(id: id,
              name: name,
              priority: priority)
    }

    init(from domain: Brand) {
        id = domain.id
        name = domain.name
        priority = domain.priority
    }
}
