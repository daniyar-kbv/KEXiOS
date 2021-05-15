//
//  MeniDetailProvider.swift
//  SalamBro
//
//  Created by Arystan on 5/3/21.
//

import Foundation
import PromiseKit

public protocol MenuDetailProvider: AnyObject {
    func downloadMenuDetail() -> Promise<DownloadMenuDetailItemReponse>
}

extension NetworkProvider: MenuDetailProvider {
    public func downloadMenuDetail() -> Promise<DownloadMenuDetailItemReponse> {
        pseudoRequest(valueToReturn: .mockResponse)
    }
}
