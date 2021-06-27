//
//  BrandStorage.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 06.05.2021.
//

import Cache
import Foundation

protocol BrandStorage: AnyObject {
    var brand: Brand? { get set }
    var brands: [Brand]? { get set }
}

extension Storage: BrandStorage {
    private enum Key: String {
        case brand
        case brands
    }

    var brand: Brand? {
        get { get(key: Key.brand.rawValue) }
        set { save(key: Key.brand.rawValue, object: newValue) }
    }

    var brands: [Brand]? {
        get { get(key: Key.brands.rawValue) }
        set { save(key: Key.brands.rawValue, object: newValue) }
    }
}
