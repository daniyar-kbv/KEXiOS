//
//  ProfilePageRepository.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 24.06.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol ProfilePageRepository: AnyObject {
    var outputs: ProfilePageRepositoryImpl.Output { get }
    func fetchUserInfo()
    func set(userInfo: UserInfoResponse)
    func logout()
}

final class ProfilePageRepositoryImpl: ProfilePageRepository {
    private let disposeBag = DisposeBag()

    private(set) var outputs: Output = .init()

    private let profileService: ProfileService
    private let authService: AuthService
    private let tokenStorage: AuthTokenStorage

    init(profileService: ProfileService, authService: AuthService, tokenStorage: AuthTokenStorage) {
        self.profileService = profileService
        self.authService = authService
        self.tokenStorage = tokenStorage
    }

    func fetchUserInfo() {
        outputs.didStartRequest.accept(())
        profileService.getUserInfo()
            .subscribe(onSuccess: { [weak self] userResponse in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didGetUserInfo.accept(userResponse)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                if let error = error as? ErrorPresentable {
                    self?.outputs.didFail.accept(error)
                    return
                }
                self?.outputs.didFail.accept(NetworkError.error(error.localizedDescription))
            })
            .disposed(by: disposeBag)
    }

    func logout() {
        tokenStorage.cleanUp()
    }

    func set(userInfo: UserInfoResponse) {
        outputs.didGetUserInfo.accept(userInfo)
    }
}

extension ProfilePageRepositoryImpl {
    struct Output {
        let didGetUserInfo = PublishRelay<UserInfoResponse>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
    }
}
