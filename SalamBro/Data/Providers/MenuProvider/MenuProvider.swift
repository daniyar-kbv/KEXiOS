//
//  BrandProvider.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import PromiseKit

public protocol MenuProvider: AnyObject {
    func downloadMenuCategories() -> Promise<DownloadMenuCategoriesResponse>
    func downloadMenuItems() -> Promise<DownloadMenuItemsResponse>
    func downloadMenuAds() -> Promise<DownloadMenuAdsResponse>
}

extension NetworkProvider: MenuProvider {
    public func downloadMenuCategories() -> Promise<DownloadMenuCategoriesResponse> {
        pseudoRequest(valueToReturn: .mockResponse)
    }
    
    public func downloadMenuItems() -> Promise<DownloadMenuItemsResponse> {
        pseudoRequest(valueToReturn: .mockResponse)
    }
    
    public func downloadMenuAds() -> Promise<DownloadMenuAdsResponse> {
        pseudoRequest(valueToReturn: .mockReponse)
    }
}
