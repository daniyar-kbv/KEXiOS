//
//  SetNameViewModel.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 31.05.2021.
//

import Foundation

final class SetNameViewModel {
    private let defaultStorage: DefaultStorage

    init(defaultStorage: DefaultStorage) {
        self.defaultStorage = defaultStorage
    }

    func persist(name: String) {
        defaultStorage.persist(name: name)
    }
}
