//
//  CountryCodePickerViewModel.swift
//  SalamBro
//
//  Created by Arystan on 3/13/21.
//

import Foundation

class CountryViewModel: NSObject {
    var countryArray: [Country]!

    override init() {
        super.init()
        getCountriesFromApi()
    }

    func getCountriesFromApi() {
//        countryArray = apiService.getCountries()
    }

    func numberOfCountries() -> Int {
        return countryArray.count
    }

    func unmarkAll() {
        for i in 0 ..< numberOfCountries() {
//            countryArray[i].marked = false
        }
    }

    func getMarked() -> Country? {
        for i in 0 ..< numberOfCountries() {
//            if countryArray[i].marked {
//                return countryArray[i]
//            }
        }
        return nil
    }
}
