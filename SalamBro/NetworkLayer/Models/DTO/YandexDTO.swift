//
//  YandexDTOs.swift
//  SalamBro
//
//  Created by Dan on 9/10/21.
//

import Foundation

struct YandexDTO: Encodable {
    var geocode: String?
    var apiKey: String?
    var language: String?
    var format: String?
    var sco: String?
    var kind: String?
    var results: String?

    func toQueryParams() -> [String: String] {
        guard let geocode = geocode, let apiKey = apiKey, let language = language,
              let format = format, let sco = sco, let kind = kind, let results = results else { return [:] }
        let queryParams = ["geocode": geocode,
                           "apikey": apiKey,
                           "lang": language,
                           "format": format,
                           "sco": sco,
                           "kind": kind,
                           "results": results]
        return queryParams
    }
}
