//
//  MenuRepositoryMockImpl.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation
import PromiseKit

public final class MenuRepositoryImplementation: MenuRepository {
    private let provider: MenuProvider
    
    public init(provider: MenuProvider) {
        self.provider = provider
    }
    
    public func downloadMenuCategories() -> Promise<DownloadMenuCategoriesResponse> {
        provider.downloadMenuCategories()
    }
    
    public func downloadMenuItems() -> Promise<DownloadMenuItemsResponse> {
        provider.downloadMenuItems()
    }
    
    public func downloadMenuAds() -> Promise<DownloadMenuAdsResponse> {
        provider.downloadMenuAds()
    }
}
