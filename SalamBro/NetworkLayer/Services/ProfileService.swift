//
//  ProfileService.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 14.06.2021.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

protocol ProfileService: AnyObject {
    func getUserInfo() -> Single<UserInfoResponse>
    func updateUserInfo(with dto: UserInfoDTO) -> Single<UserInfoResponse>
    func getAddresses() -> Single<[UserAddress]>
    func updateAddress(dto: UpdateAddressDTO) -> Single<String>
    func deleteAddress(id: Int) -> Single<Void>
}

final class ProfileServiceMoyaImpl: ProfileService {
    private let disposeBag = DisposeBag()

    private let provider: MoyaProvider<ProfileAPI>

    init(provider: MoyaProvider<ProfileAPI>) {
        self.provider = provider
    }

    func getUserInfo() -> Single<UserInfoResponse> {
        return provider.rx
            .request(.getUserInfo)
            .map { response in
                guard
                    let userInfoContainerResponse = try? response.map(UserInfoResponseContainer.self)
                else {
                    throw NetworkError.badMapping
                }

                if let error = userInfoContainerResponse.error {
                    throw error
                }

                guard let userInfo = userInfoContainerResponse.data else {
                    throw NetworkError.badMapping
                }

                return userInfo
            }
    }

    func updateUserInfo(with dto: UserInfoDTO) -> Single<UserInfoResponse> {
        return provider.rx
            .request(.editUserInfo(dto: dto))
            .map { response in
                guard let userInfoResponse = try? response.map(UserInfoResponseContainer.self) else {
                    throw NetworkError.badMapping
                }

                if let error = userInfoResponse.error {
                    throw error
                }

                guard let userInfo = userInfoResponse.data else {
                    throw NetworkError.badMapping
                }

                return userInfo
            }
    }

    func getAddresses() -> Single<[UserAddress]> {
        return provider.rx
            .request(.getAddresses)
            .map { response in
                guard let response = try? response.map(UserAddressesResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = response.error {
                    throw error
                }

                guard let addresses = response.data else {
                    throw NetworkError.noData
                }

                return addresses
            }
    }

    func updateAddress(dto: UpdateAddressDTO) -> Single<String> {
        provider.rx
            .request(.updateAddress(dto: dto))
            .map { response in

                guard let response = try? response.map(OrderApplyResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = response.error {
                    throw error
                }

                return response.data?.uuid ?? ""
            }
    }

    func deleteAddress(id: Int) -> Single<Void> {
        provider.rx
            .request(.deleteAddress(id: id))
            .map { response in
                guard response.response?.statusCode == Constants.StatusCode.noContent else {
                    guard let response = try? response.map(OrderApplyResponse.self) else {
                        throw NetworkError.badMapping
                    }

                    if let error = response.error {
                        throw error
                    }
                    return
                }

                return ()
            }
    }
}
