//
//  MenuDetailRepositoryImplementation.swift
//  SalamBro
//
//  Created by Arystan on 5/4/21.
//

import Foundation
import PromiseKit

public final class MenuDetailRepositoryImplementation: MenuDetailRepository {
    private let provider: MenuDetailProvider

    public init(provider: MenuDetailProvider) {
        self.provider = provider
    }

    public func downloadMenuDetail() -> Promise<Food> {
        provider.downloadMenuDetail().map {
            $0.menuDetailItem.toDomain()
        }
    }
}
