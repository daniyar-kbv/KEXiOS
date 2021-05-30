//
//  AuthAPI.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 30.05.2021.
//

import Moya

enum AuthAPI {
    case sendOTP(dto: SendOTPDTO)
    case verifyOTP(dto: OTPVerifyDTO)
    case resendOTP(dto: SendOTPDTO)
    case refreshToken(dto: RefreshDTO)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return devBaseUrl
    }

    var path: String {
        switch self {
        case .sendOTP: return "auth/register/"
        case .verifyOTP: return "auth/otp_verify/"
        case .resendOTP: return "auth/otp_resend/"
        case .refreshToken: return "auth/refresh/"
        }
    }

    var method: Method {
        switch self {
        case .sendOTP: return .post
        case .verifyOTP: return .post
        case .resendOTP: return .post
        case .refreshToken: return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .sendOTP(dto):
            return .requestCustomJSONEncodable(dto, encoder: JSONEncoder())
        case let .verifyOTP(dto): return .requestJSONEncodable(dto)
        case let .resendOTP(dto): return .requestJSONEncodable(dto)
        case let .refreshToken(dto): return .requestJSONEncodable(dto)
        }
    }

    var headers: [String: String]? {
        let header = [
            "Content-Type": "application/json",
            "language": "ru",
        ]

        return header
    }
}
