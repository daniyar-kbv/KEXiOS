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
    var currentCity: String? { get set }
    var countries: [Country] { get }
    var cities: [String] { get }
    var addresses: [Address]? { get set }
    var currentAddress: Address? { get set }
//    func downloadCountries() -> Promise<[Country]>
    func downloadCities(country id: Int) -> Promise<[String]>
}
