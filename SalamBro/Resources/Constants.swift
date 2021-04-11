//
//  Constants.swift
//  SalamBro
//
//  Created by Arystan on 4/12/21.
//

import Foundation


public var apiKey: String {
  get {
    guard let filePath = Bundle.main.path(forResource: "SalamBro-Info", ofType: "plist") else {
      fatalError("Couldn't find file 'TMDB-Info.plist'.")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: "API_KEY") as? String else {
      fatalError("Couldn't find key 'API_KEY' in 'SalamBro-Info.plist'.")
    }
    return value
  }
}
