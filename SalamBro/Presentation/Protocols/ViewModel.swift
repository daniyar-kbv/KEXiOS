//
//  ViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation

public protocol ViewModel: AnyObject {
    var router: Router { get }
    func close()
}

public extension ViewModel {
    func close() {
        router.dismiss()
    }
}
