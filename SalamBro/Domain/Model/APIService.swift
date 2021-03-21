//
//  APIService.swift
//  SalamBro
//
//  Created by Arystan on 3/13/21.
//

import Foundation

class APIService :  NSObject {
    
//    private let sourcesURL = URL(string: "")!
//
//    func getCountries(completion : @escaping ([Country]) -> ()){
//        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
//            dump(data)
//            dump(urlResponse)
//            dump(error)
//            if let data = data {
//
//                let jsonDecoder = JSONDecoder()
//
//                let empData = try! jsonDecoder.decode([Country].self, from: data)
//                    completion(empData)
//            }
//        }.resume()
//    }
    func getCountries() -> [Country] {
        var temp: [Country] = []
        let ids = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19"]
        let names = ["Kazakhstan", "Russian Federation", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA","Kazakhstan", "Russian Federation", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA"]
        let callingCodes = ["+7", "+7", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1","+7", "+7", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1","+7", "+7", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1"]
//        let markArray = [false, false, false, false, false, false, false, false, false,false, false, false, false, false, false, false, false, false, false,false, false, false, false, false, false, false, false, false, false,false, false, false, false, false, false, false, false, false, false,false]
        for i in 0..<40 { // this will add 10 elements to contacts
            temp.append(Country(id: ids[i], name: names[i], callingCode: callingCodes[i]))
        }
        temp[0].marked = true
        return temp
    }
    
}
