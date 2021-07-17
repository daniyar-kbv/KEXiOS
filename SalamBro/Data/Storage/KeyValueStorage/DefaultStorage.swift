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
    case fcmToken
    case appLocale
    case isFirstLaunch

    var value: String { return rawValue }
}

protocol DefaultStorage {
    var userName: String? { get }
    var leadUUID: String? { get }
    var fcmToken: String? { get }
    var appLocale: String? { get }
    var isFirstLaunch: Bool { get }

    func persist(name: String)
    func persist(leadUUID: String)
    func persist(fcmToken: String)
    func persist(appLocale: String)

    func cleanUp(key: DefaultStorageKey)
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

    var fcmToken: String? {
        return storageProvider.string(forKey: DefaultStorageKey.fcmToken.value)
    }

    var isFirstLaunch: Bool {
        return storageProvider.bool(forKey: DefaultStorageKey.isFirstLaunch.value)
    }

    var appLocale: String? {
        return storageProvider.string(forKey: DefaultStorageKey.appLocale.value)
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

    func persist(fcmToken: String) {
        storageProvider.set(fcmToken, forKey: DefaultStorageKey.fcmToken.value)
    }

    func persist(appLocale: String) {
        storageProvider.set(appLocale, forKey: DefaultStorageKey.appLocale.value)
    }

    func cleanUp(key: DefaultStorageKey) {
        let empty = ""
        storageProvider.set(empty, forKey: key.value)
    }
}
