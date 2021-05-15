//
//  BrandRepository.swift
//  SalamBro
//
//  Created by Murager on 11.03.2021.
//

import Foundation
import PromiseKit

public protocol BrandRepository: AnyObject {
    var brand: Brand? { get set }
    var brands: [Brand] { get }
    func downloadBrands() -> Promise<([Brand], [(Float, Float)])>
}
