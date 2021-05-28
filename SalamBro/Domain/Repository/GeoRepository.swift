//
//  GeoRepository.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation
import PromiseKit

protocol GeoRepository: AnyObject {
    var currentCountry: Country? { get set }
    var currentCity: City? { get set }
    var countries: [Country] { get }
    var cities: [City] { get }
    var addresses: [Address]? { get set }
    var currentAddress: Address? { get set }
}
