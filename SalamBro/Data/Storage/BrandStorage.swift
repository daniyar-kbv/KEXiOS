//
//  BrandStorage.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 06.05.2021.
//

import Cache
import Foundation

public protocol BrandStorage: AnyObject {
    var brand: BrandDTO? { get set }
    var brands: [BrandDTO]? { get set }
}

extension Storage: BrandStorage {
    private enum Key: String {
        case brand
        case brands
    }

    public var brand: BrandDTO? {
        get { get(key: Key.brand.rawValue) }
        set { save(key: Key.brand.rawValue, object: newValue) }
    }

    public var brands: [BrandDTO]? {
        get { get(key: Key.brands.rawValue) }
        set { save(key: Key.brands.rawValue, object: newValue) }
    }
}
