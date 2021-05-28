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
