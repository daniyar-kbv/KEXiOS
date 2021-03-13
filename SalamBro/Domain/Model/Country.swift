//
//  Country.swift
//  SalamBro
//
//  Created by Arystan on 3/13/21.
//

import Foundation

public struct Country: Decodable {
    let id: String
    let name: String
    let callingCode: String
    var marked: Bool = false
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case callingCode
//    }
}


