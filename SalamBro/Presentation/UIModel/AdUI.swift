//
//  Ad.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation

public struct AdUI {
    let name: String
}

public extension AdUI {
    func toDomain() -> Ad {
        .init(name: name)
    }

    init(from domain: Ad) {
        name = domain.name
    }
}
