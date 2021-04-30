//
//  Models.swift
//  SalamBro
//
//  Created by Arystan on 4/27/21.
//

import Foundation

struct Food: Decodable {
    let id:                 Int
    let title:              String
    let price:              Int
    let description:        String
}
