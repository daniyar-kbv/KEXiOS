//
//  Providers.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Alamofire
import Foundation
import PromiseKit

public final class NetworkProvider {
    public func pseudoRequest<T: Decodable>(valueToReturn: T) -> Promise<T> {
        return .init { seal in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                seal.fulfill(valueToReturn)
            }
        }
    }
}
