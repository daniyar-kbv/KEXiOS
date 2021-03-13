//
//  CountryCodePickerViewModel.swift
//  SalamBro
//
//  Created by Arystan on 3/13/21.
//

import Foundation

class CountryViewModel: NSObject {
    
    private var apiService: APIService!
    
    var countryArray : [Country]!
    
    override init() {
        super.init()
        self.apiService = APIService()
        getCountriesFromApi()
    }
    
    func getCountriesFromApi() {
//        apiService.getCountries { (data) in
//            self.countryArray = data
//            dump(self.countryArray)
//        }
        countryArray = apiService.getCountries()
    }
    
    func numberOfCountries() -> Int {
        return countryArray.count
    }
    
    func unmarkAll() {
        for i in 0..<numberOfCountries() { // this will add 10 elements to contacts
            countryArray[i].marked = false
        }
//        for i in countryArray {
//            i.marked = false
//        }
    }
    
    func getMarked() -> Country? {
        for i in 0..<numberOfCountries() { // this will add 10 elements to contacts
            if countryArray[i].marked {
                return countryArray[i]
            }
        }
        return nil
    }
}
