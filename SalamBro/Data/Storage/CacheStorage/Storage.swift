//
//  Storage.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Cache
import Foundation

public final class Storage {
    private enum Keys: String {
        case disk
    }

    private func cache<T: Codable>(objectType _: T.Type) throws -> Cache.Storage<String, T> {
        let applicationSupportURL = try? FileManager.default.url(for: .applicationSupportDirectory,
                                                                 in: .userDomainMask,
                                                                 appropriateFor: nil,
                                                                 create: true)
        let diskConfig = DiskConfig(name: Keys.disk.rawValue,
                                    expiry: .never,
                                    directory: applicationSupportURL)
        let memoryConfig = MemoryConfig(expiry: .never,
                                        countLimit: 0,
                                        totalCostLimit: 0)
        return try Cache.Storage<String, T>(diskConfig: diskConfig,
                                            memoryConfig: memoryConfig,
                                            transformer: TransformerFactory.forCodable(ofType: T.self))
    }

    internal func save<T: Codable>(key: String, object: T?) {
        if let object = object {
            try? cache(objectType: T.self).setObject(object, forKey: key)
        } else {
            try? cache(objectType: T.self).removeObject(forKey: key)
        }
    }

    internal func get<T: Codable>(key: String) -> T? {
        return try? cache(objectType: T.self).object(forKey: key)
    }
}
