//
//  ProfileAPI.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 14.06.2021.
//

import Moya

enum ProfileAPI {
    case getUserInfo
    case editUserInfo(dto: UserInfoDTO)
}

extension ProfileAPI: TargetType {
    var baseURL: URL {
        return devBaseUrl
    }

    var path: String {
        switch self {
        case .getUserInfo: return "users/account-info/"
        case .editUserInfo: return "users/account-update/"
        }
    }

    var method: Method {
        switch self {
        case .editUserInfo: return .post
        case .getUserInfo: return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getUserInfo: return .requestPlain
        case let .editUserInfo(dto): return .requestJSONEncodable(dto)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
