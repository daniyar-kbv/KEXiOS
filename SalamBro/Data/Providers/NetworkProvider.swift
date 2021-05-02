//
//  Providers.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import PromiseKit
import Alamofire

public final class NetworkProvider {
    public func pseudoRequest<T: Decodable>(valueToReturn: T) -> Promise<T> {
        return .value(valueToReturn)
    }
}
