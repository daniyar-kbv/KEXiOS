//
//  DefaultStorage.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 31.05.2021.
//

import Foundation

enum DefaultStorageKey: String, StorageKey, Equatable {
    case username

    var value: String { return rawValue }
}

protocol DefaultStorage {
    func persist(name: String)
    func cleanUp()
    var userName: String? { get }
}

final class DefaultStorageImpl: DefaultStorage {
    static let sharedStorage = DefaultStorageImpl(storageProvider: UserDefaults.standard)

    private let storageProvider: UserDefaults

    var userName: String? {
        return storageProvider.string(forKey: DefaultStorageKey.username.value)
    }

    init(storageProvider: UserDefaults) {
        self.storageProvider = storageProvider
    }

    func persist(name: String) {
        storageProvider.set(name, forKey: DefaultStorageKey.username.value)
    }

    func cleanUp() {
        let empty = ""
        storageProvider.set(empty, forKey: DefaultStorageKey.username.value)
    }
}
