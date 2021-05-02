//
//  MenuRepository.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation
import PromiseKit

public protocol MenuRepository {
    func downloadMenuCategories() -> Promise<DownloadMenuCategoriesResponse>
    func downloadMenuItems() -> Promise<DownloadMenuItemsResponse>
    func downloadMenuAds() -> Promise<DownloadMenuAdsResponse>
}
