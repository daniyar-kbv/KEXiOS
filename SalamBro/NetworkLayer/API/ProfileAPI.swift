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
    case getAddresses
    case updateAddress(dto: UpdateAddressDTO)
    case deleteAddress(id: Int)
}

extension ProfileAPI: TargetType {
    var baseURL: URL {
        return Constants.URLs.APIBase.dev
    }

    var path: String {
        switch self {
        case .getUserInfo: return "users/account-info/"
        case .editUserInfo: return "users/account-update/"
        case .getAddresses: return "/users/addresses/"
        case .updateAddress: return "/orders/authorized-apply/"
        case let .deleteAddress(id): return "/users/addresses/\(id)/"
        }
    }

    var method: Method {
        switch self {
        case .editUserInfo: return .post
        case .getUserInfo: return .get
        case .getAddresses: return .get
        case .updateAddress: return .post
        case .deleteAddress: return .delete
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getUserInfo: return .requestPlain
        case let .editUserInfo(dto): return .requestJSONEncodable(dto)
        case .getAddresses: return .requestPlain
        case let .updateAddress(dto): return .requestJSONEncodable(dto)
        case .deleteAddress: return .requestPlain
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
