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

                return userInfoContainerResponse.data
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

                return userInfoResponse.data
            }
    }
}
