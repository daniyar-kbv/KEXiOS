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
    case notFirstLaunch

    var value: String { return rawValue }
}

protocol DefaultStorage {
    var userName: String? { get }
    var leadUUID: String? { get }
    var fcmToken: String? { get }
    var appLocale: String { get }
    var notFirstLaunch: Bool { get }

    func persist(name: String)
    func persist(leadUUID: String)
    func persist(fcmToken: String)
    func persist(appLocale: Language.LanguageTableItem)
    func persist(notFirstLaunch: Bool)

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

    var notFirstLaunch: Bool {
        return storageProvider.bool(forKey: DefaultStorageKey.notFirstLaunch.value)
    }

    var appLocale: String {
        return storageProvider.string(forKey: DefaultStorageKey.appLocale.value) ?? Language.LanguageTableItem.russian.code
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

    func persist(appLocale: Language.LanguageTableItem) {
        storageProvider.set(appLocale.code, forKey: DefaultStorageKey.appLocale.value)
    }

    func persist(notFirstLaunch: Bool) {
        storageProvider.set(notFirstLaunch, forKey: DefaultStorageKey.notFirstLaunch.value)
    }

    func cleanUp(key: DefaultStorageKey) {
        storageProvider.set(nil, forKey: key.value)
    }
}
