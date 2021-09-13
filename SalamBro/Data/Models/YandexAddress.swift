//
//  YandexAddress.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 9/10/21.
//

import Foundation

struct YandexAddress: Decodable {
    let response: YandexResponse?
}

struct YandexResponse: Decodable {
    let geoObjectCollection: GeoObjectCollection

    enum CodingKeys: String, CodingKey {
        case geoObjectCollection = "GeoObjectCollection"
    }
}

struct GeoObjectCollection: Decodable {
    let metaDataProperty: GeoObjectCollectionMetaDataProperty
    let featureMember: [FeatureMember]
}

struct FeatureMember: Decodable {
    let geoObject: GeoObject

    enum CodingKeys: String, CodingKey {
        case geoObject = "GeoObject"
    }
}

struct GeoObject: Decodable {
    let metaDataProperty: GeoObjectMetaDataProperty
    let name, geoObjectDescription: String
    let boundedBy: BoundedBy
    let point: Point

    enum CodingKeys: String, CodingKey {
        case metaDataProperty, name
        case geoObjectDescription = "description"
        case boundedBy
        case point = "Point"
    }
}

struct BoundedBy: Decodable {
    let envelope: Envelope

    enum CodingKeys: String, CodingKey {
        case envelope = "Envelope"
    }
}

struct Envelope: Codable {
    let lowerCorner, upperCorner: String
}

struct GeoObjectMetaDataProperty: Decodable {
    let geocoderMetaData: GeocoderMetaData

    enum CodingKeys: String, CodingKey {
        case geocoderMetaData = "GeocoderMetaData"
    }
}

struct GeocoderMetaData: Decodable {
    let precision, text, kind: String
    let address: YandexMapAddress
    let addressDetails: AddressDetails

    enum CodingKeys: String, CodingKey {
        case precision, text, kind
        case address = "Address"
        case addressDetails = "AddressDetails"
    }
}

struct YandexMapAddress: Decodable {
    let countryCode, formatted: String
    let components: [Component]

    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case formatted
        case components = "Components"
    }
}

struct Component: Decodable {
    let kind, name: String
}

struct AddressDetails: Decodable {
    let country: YandexCountry

    enum CodingKeys: String, CodingKey {
        case country = "Country"
    }
}

struct YandexCountry: Decodable {
    let addressLine, countryNameCode, countryName: String
    let administrativeArea: AdministrativeArea

    enum CodingKeys: String, CodingKey {
        case addressLine = "AddressLine"
        case countryNameCode = "CountryNameCode"
        case countryName = "CountryName"
        case administrativeArea = "AdministrativeArea"
    }
}

struct AdministrativeArea: Decodable {
    let administrativeAreaName: String
    let locality: Locality

    enum CodingKeys: String, CodingKey {
        case administrativeAreaName = "AdministrativeAreaName"
        case locality = "Locality"
    }
}

struct Locality: Decodable {
    let localityName: String
    let thoroughfare: Thoroughfare

    enum CodingKeys: String, CodingKey {
        case localityName = "LocalityName"
        case thoroughfare = "Thoroughfare"
    }
}

struct Thoroughfare: Decodable {
    let thoroughfareName: String
    let premise: Premise

    enum CodingKeys: String, CodingKey {
        case thoroughfareName = "ThoroughfareName"
        case premise = "Premise"
    }
}

struct Premise: Decodable {
    let premiseNumber: String

    enum CodingKeys: String, CodingKey {
        case premiseNumber = "PremiseNumber"
    }
}

struct Point: Decodable {
    let pos: String
}

struct GeoObjectCollectionMetaDataProperty: Decodable {
    let geocoderResponseMetaData: GeocoderResponseMetaData

    enum CodingKeys: String, CodingKey {
        case geocoderResponseMetaData = "GeocoderResponseMetaData"
    }
}

struct GeocoderResponseMetaData: Decodable {
    let point: Point?
    let boundedBy: BoundedBy
    let request, results, found: String

    enum CodingKeys: String, CodingKey {
        case boundedBy, request, results, found
        case point = "Point"
    }
}
