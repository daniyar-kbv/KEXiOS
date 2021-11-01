//
//  DocumentsAPI.swift
//  SalamBro
//
//  Created by Dan on 6/24/21.
//

import Moya

enum DocumentsAPI {
    case documents
    case contacts
}

extension DocumentsAPI: TargetType {
    var baseURL: URL {
        return Constants.URLs.apiBaseURL
    }

    var path: String {
        switch self {
        case .documents:
            return "documents/"
        case .contacts:
            return "documents/contacts/"
        }
    }

    var method: Method {
        switch self {
        case .documents: return .get
        case .contacts: return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .documents: return .requestPlain
        case .contacts: return .requestPlain
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
