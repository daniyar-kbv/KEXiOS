//
//  DefaultStorage.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 31.05.2021.
//

import Foundation

enum DefaultStorageKey: String, StorageKey, Equatable {
    case username
    case leadUUID

    var value: String { return rawValue }
}

protocol DefaultStorage {
    var userName: String? { get }
    var leadUUID: String? { get }
    func persist(name: String)
    func persist(leadUUID: String)
    
    func cleanUp()
}

final class DefaultStorageImpl: DefaultStorage {
    static let sharedStorage = DefaultStorageImpl(storageProvider: UserDefaults.standard)

    private let storageProvider: UserDefaults

    var userName: String? {
        return storageProvider.string(forKey: DefaultStorageKey.username.value)
    }
    
    var leadUUID: String? {
        return storageProvider.string(forKey: DefaultStorageKey.leadUUID.value)
    }

    init(storageProvider: UserDefaults) {
        self.storageProvider = storageProvider
    }

    func persist(name: String) {
        storageProvider.set(name, forKey: DefaultStorageKey.username.value)
    }
    
    func persist(leadUUID: String) {
        storageProvider.set(leadUUID, forKey: DefaultStorageKey.leadUUID.value)
    }

    func cleanUp() {
        let empty = ""
        storageProvider.set(empty, forKey: DefaultStorageKey.username.value)
    }
}
