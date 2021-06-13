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
            .debug()
            .map { response in
                guard
                    let userInfoContainerResponse = try? response.map(UserInfoResponseContainer.self),
                    let userInfo = userInfoContainerResponse.results.first
                else {
                    throw NetworkError.badMapping
                }

                return userInfo
            }
    }

    func updateUserInfo(with dto: UserInfoDTO) -> Single<UserInfoResponse> {
        return provider.rx
            .request(.editUserInfo(dto: dto))
            .debug()
            .map { response in
                guard let userInfoResponse = try? response.map(UserInfoResponse.self) else {
                    throw NetworkError.badMapping
                }

                return userInfoResponse
            }
    }
}
