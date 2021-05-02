//
//  BrandProvider.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation
import PromiseKit

public protocol BrandProvider: AnyObject {
    func downloadBrands() -> Promise<DownloadBrandsResponse>
}

extension NetworkProvider: BrandProvider {
    public func downloadBrands() -> Promise<DownloadBrandsResponse> {
        pseudoRequest(valueToReturn: .mockResponse)
    }
}
