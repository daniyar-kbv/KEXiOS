//
//  BrandRepository.swift
//  SalamBro
//
//  Created by Murager on 11.03.2021.
//

import Foundation
import PromiseKit

public protocol BrandRepository {
    func downloadBrands() -> Promise<([Brand], [(Float, Float)])>
}
