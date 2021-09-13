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
    let point: Point

    enum CodingKeys: String, CodingKey {
        case metaDataProperty
        case point = "Point"
    }
}

struct GeoObjectMetaDataProperty: Decodable {
    let geocoderMetaData: GeocoderMetaData

    enum CodingKeys: String, CodingKey {
        case geocoderMetaData = "GeocoderMetaData"
    }
}

struct GeocoderMetaData: Decodable {
    let address: AddressFromYandex

    enum CodingKeys: String, CodingKey {
        case address = "Address"
    }
}

struct AddressFromYandex: Decodable {
    let components: [Component]

    enum CodingKeys: String, CodingKey {
        case components = "Components"
    }
}

struct Component: Decodable {
    let kind, name: String
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

    enum CodingKeys: String, CodingKey {
        case point = "Point"
    }
}
