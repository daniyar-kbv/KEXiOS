//
//  NetworkError.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 26.05.2021.
//

import Foundation

protocol ErrorPresentable: Error {
    var presentationDescription: String { get }
}

enum NetworkError: ErrorPresentable, Equatable {
    case badMapping
    case noData
    case unauthorized
    case error(String)

    var presentationDescription: String {
        switch self {
        case .badMapping: return SBLocalization.localized(key: ErrorText.Network.mappingError)
        case .noData: return SBLocalization.localized(key: ErrorText.Network.noData)
        case .unauthorized: return SBLocalization.localized(key: ErrorText.Network.unauthorized)
        case let .error(error): return error
        }
    }
}

struct ErrorResponse: Codable, ErrorPresentable {
    let code: String
    let message: String

    var presentationDescription: String {
        #if DEBUG
            return code
        #else
            return message
        #endif
    }
}
