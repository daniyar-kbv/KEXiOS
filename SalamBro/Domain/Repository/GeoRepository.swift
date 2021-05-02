//
//  GeoRepository.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation
import PromiseKit

public protocol GeoRepository: AnyObject {
    var currentCountry: Country? { get set }
    func downloadCountries() -> Promise<[Country]>
    func downloadCities(country id: Int) -> Promise<[String]>
}
