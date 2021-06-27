//
//  SecureStorageProvider.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 31.05.2021.
//

import KeychainAccess

protocol StorageKey {
    var value: String { get }
}

protocol SecureStorageProvider: AnyObject {
    func getData(for key: StorageKey) -> Data?
    func set(_ data: Data, for key: StorageKey)

    func getString(for key: StorageKey) -> String?
    func set(_ string: String?, for key: StorageKey)

    func getURL(for key: StorageKey) -> URL?
    func set(_ url: URL?, for key: StorageKey)
}

extension Keychain: SecureStorageProvider {
    func getData(for key: StorageKey) -> Data? {
        let data = self[data: key.value]
        if data?.count == 0 { return nil }
        return data
    }

    func set(_ data: Data, for key: StorageKey) {
        self[data: key.value] = data
    }

    func getString(for key: StorageKey) -> String? {
        guard let data = getData(for: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func set(_ string: String?, for key: StorageKey) {
        set(string?.data(using: .utf8) ?? Data(), for: key)
    }

    func getURL(for key: StorageKey) -> URL? {
        guard let data = getData(for: key) else { return nil }
        return URL(dataRepresentation: data, relativeTo: nil)
    }

    func set(_ url: URL?, for key: StorageKey) {
        set(url?.dataRepresentation ?? Data(), for: key)
    }
}
