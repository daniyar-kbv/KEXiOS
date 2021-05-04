//
//  MenuDetailRepository.swift
//  SalamBro
//
//  Created by Arystan on 5/3/21.
//

import Foundation
import PromiseKit

public protocol MenuDetailRepository {
    func downloadMenuDetail() -> Promise<Food>
}
