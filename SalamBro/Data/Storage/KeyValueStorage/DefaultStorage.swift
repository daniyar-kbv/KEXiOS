//
//  DefaultStorage.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 31.05.2021.
//

import Foundation

enum DefaultStorageKey: String, StorageKey, Equatable {
    case leadUUID
    case fcmToken
    case appLocale
    case notFirstLaunch
    case isPaymentProcess

    var value: String { return rawValue }
}

protocol DefaultStorage {
    var leadUUID: String? { get }
    var fcmToken: String? { get }
    var appLocale: Language { get }
    var notFirstLaunch: Bool { get }
    var isPaymentProcess: Bool { get }

    func persist(leadUUID: String)
    func persist(fcmToken: String)
    func persist(appLocale: Language)
    func persist(notFirstLaunch: Bool)
    func persist(isPaymentProcess: Bool)

    func cleanUp(key: DefaultStorageKey)
}

final class DefaultStorageImpl: DefaultStorage {
    static let sharedStorage = DefaultStorageImpl(storageProvider: UserDefaults.standard)

    private let storageProvider: UserDefaults

    init(storageProvider: UserDefaults) {
        self.storageProvider = storageProvider
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

    var appLocale: Language {
        return Language.get(by: storageProvider.string(forKey: DefaultStorageKey.appLocale.value))
    }

    var isPaymentProcess: Bool {
        return storageProvider.bool(forKey: DefaultStorageKey.isPaymentProcess.value)
    }

    func persist(leadUUID: String) {
        storageProvider.set(leadUUID, forKey: DefaultStorageKey.leadUUID.value)
    }

    func persist(fcmToken: String) {
        storageProvider.set(fcmToken, forKey: DefaultStorageKey.fcmToken.value)
    }

    func persist(appLocale: Language) {
        storageProvider.set(appLocale.code, forKey: DefaultStorageKey.appLocale.value)
    }

    func persist(notFirstLaunch: Bool) {
        storageProvider.set(notFirstLaunch, forKey: DefaultStorageKey.notFirstLaunch.value)
    }

    func persist(isPaymentProcess: Bool) {
        storageProvider.set(isPaymentProcess, forKey: DefaultStorageKey.isPaymentProcess.value)
    }

    func cleanUp(key: DefaultStorageKey) {
        storageProvider.set(nil, forKey: key.value)
    }
}
