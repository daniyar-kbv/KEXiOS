//
//  LocationAPI.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 26.05.2021.
//

import Moya

enum LocationAPI {
    case getAllCountries
    case getCities(countryId: Int)
    case getCityBrands(cityId: Int)
    case getAllBrands
}

extension LocationAPI: TargetType {
    var baseURL: URL {
        return Constants.URLs.APIBase.dev
    }

    var path: String {
        switch self {
        case .getAllCountries: return "location/countries/"
        case let .getCities(countryId): return "location/countries/\(countryId)"
        case let .getCityBrands(cityId): return "partners/brands_of_city/\(cityId)"
        case .getAllBrands: return "partners/brands/"
        }
    }

    var method: Method {
        switch self {
        case .getAllCountries: return .get
        case .getCities: return .get
        case .getCityBrands: return .get
        case .getAllBrands: return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getAllCountries: return .requestPlain
        case .getCities: return .requestPlain
        case .getCityBrands: return .requestPlain
        case .getAllBrands: return .requestPlain
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
