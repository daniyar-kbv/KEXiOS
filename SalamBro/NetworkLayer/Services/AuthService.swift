//
//  AuthService.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 30.05.2021.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

protocol AuthService: AnyObject {
    func authorize(with dto: SendOTPDTO) -> Single<Void>
    func verifyOTP(with dto: OTPVerifyDTO) -> Single<AccessToken>
    func resendOTP(with dto: SendOTPDTO) -> Single<Void>
}

final class AuthServiceMoyaImpl: AuthService {
    private let provider: MoyaProvider<AuthAPI>

    init(provider: MoyaProvider<AuthAPI>) {
        self.provider = provider
    }

    func authorize(with dto: SendOTPDTO) -> Single<Void> {
        return provider.rx
            .request(.sendOTP(dto: dto))
            .map { response in
                guard let authResponse = try? response.map(RegisterResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = authResponse.error {
                    throw error
                }
            }
    }

    func verifyOTP(with dto: OTPVerifyDTO) -> Single<AccessToken> {
        return provider.rx
            .request(.verifyOTP(dto: dto))
            .map { response in
                guard let tokenResponse = try? response.map(AccessTokenResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = tokenResponse.error {
                    throw error
                }

                guard let token = tokenResponse.data else {
                    throw NetworkError.noData
                }

                return token
            }
    }

    func resendOTP(with dto: SendOTPDTO) -> Single<Void> {
        return provider.rx
            .request(.resendOTP(dto: dto))
            .map { response in
                guard let authResponse = try? response.map(RegisterResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = authResponse.error {
                    throw error
                }
            }
    }
}
