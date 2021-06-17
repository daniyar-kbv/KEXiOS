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

enum NetworkError: ErrorPresentable {
    case badMapping
    case error(String)

    var presentationDescription: String {
        switch self {
        case .badMapping: return "Mapping error"
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
        #endif

        // MARK: Tech debt, before upload to AppStore uncomment this 👇🏻  code and comment ⬆️ code

//        return message
    }
}
