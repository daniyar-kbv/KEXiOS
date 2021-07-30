//
//  City.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 27.05.2021.
//

import Foundation

public class City: Codable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double

    init(id: Int, name: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension City {
    func getCopy() -> City {
        return .init(id: id, name: name, latitude: latitude, longitude: longitude)
    }
}

extension City: Equatable {
    public static func == (lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id || lhs.name == rhs.name
    }
}
