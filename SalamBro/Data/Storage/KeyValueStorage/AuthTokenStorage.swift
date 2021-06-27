//
//  AuthTokenStorage.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 31.05.2021.
//

import KeychainAccess

protocol AuthTokenStorage: AnyObject {
    var token: String? { get }
    var refreshToken: String? { get }

    func persist(token: String, refreshToken: String)
    func cleanUp()
}

enum AuthTokenStorageKey: String, StorageKey, Equatable {
    case authToken
    case authRefreshToken

    var value: String { return rawValue }
}

final class AuthTokenStorageImpl: AuthTokenStorage {
    // MARK: - Public Variables

    static let sharedStorage = AuthTokenStorageImpl(secureStorageProvider: Keychain())

    var token: String? {
        return secureStorageProvider.getString(for: AuthTokenStorageKey.authToken)
    }

    var refreshToken: String? {
        return secureStorageProvider.getString(for: AuthTokenStorageKey.authRefreshToken)
    }

    private let secureStorageProvider: SecureStorageProvider

    init(secureStorageProvider: SecureStorageProvider) {
        self.secureStorageProvider = secureStorageProvider
    }

    func persist(token: String, refreshToken: String) {
        secureStorageProvider.set(token, for: AuthTokenStorageKey.authToken)
        secureStorageProvider.set(refreshToken, for: AuthTokenStorageKey.authRefreshToken)
    }

    func cleanUp() {
        let emptyValue: String? = nil
        secureStorageProvider.set(emptyValue, for: AuthTokenStorageKey.authToken)
        secureStorageProvider.set(emptyValue, for: AuthTokenStorageKey.authRefreshToken)
    }
}
