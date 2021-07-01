//
//  CitiesApi.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/1/21.
//

import Moya

enum CitiesAPI {
    case getCities(countryId: Int)
}

extension CitiesAPI: TargetType {
    var baseURL: URL {
        return devBaseUrl
    }

    var path: String {
        switch self {
        case let .getCities(countryId): return "location/countries/\(countryId)"
        }
    }

    var method: Method {
        switch self {
        case .getCities: return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getCities: return .requestPlain
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
