//
//  GeoProvider.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation
import PromiseKit

protocol GeoProvider: AnyObject {
//    func downloadCountries() -> Promise<DownloadCountriesReponse>
    func downloadCities(country id: Int) -> Promise<DownloadCitiesResponse>
}

extension NetworkProvider: GeoProvider {
    public func downloadCities(country _: Int) -> Promise<DownloadCitiesResponse> {
        pseudoRequest(valueToReturn: .mockResponse)
    }

//    public func downloadCountries() -> Promise<DownloadCountriesReponse> {
//        pseudoRequest(valueToReturn: .mockResponse)
//    }
}
