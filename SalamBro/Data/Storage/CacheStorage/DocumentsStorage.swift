//
//  DocumentsStorage.swift
//  SalamBro
//
//  Created by Dan on 7/5/21.
//

import Foundation

protocol DocumentsStorage: AnyObject {
    var documents: [Document] { get set }
    var contacts: [Contact] { get set }
}

extension Storage: DocumentsStorage {
    private enum Keys: String {
        case documents
        case contacts
    }

    var documents: [Document] {
        get { get(key: Keys.documents.rawValue) ?? [] }
        set { save(key: Keys.documents.rawValue, object: newValue) }
    }

    var contacts: [Contact] {
        get { get(key: Keys.contacts.rawValue) ?? [] }
        set { save(key: Keys.contacts.rawValue, object: newValue) }
    }
}
