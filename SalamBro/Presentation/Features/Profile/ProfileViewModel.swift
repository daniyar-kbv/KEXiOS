//
//  ProfileViewModel.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 13.06.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol ProfileViewModel: AnyObject {
    var tableItems: [ProfileTableItem] { get }
    var outputs: ProfileViewModelImpl.Output { get }
    func getUserInfo()
}

final class ProfileViewModelImpl: ProfileViewModel {
    private let disposeBag = DisposeBag()
    private(set) var tableItems: [ProfileTableItem] = [
        .orderHistory,
        .changeLanguage,
        .deliveryAddress,
    ]

    private(set) var outputs: Output = .init()

    private let profileService: ProfileService
    private let authService: AuthService

    init(profileService: ProfileService, authService: AuthService) {
        self.profileService = profileService
        self.authService = authService
    }

    func getUserInfo() {
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
}

extension ProfileViewModelImpl {
    struct Output {
        let didGetUserInfo = PublishRelay<UserInfoResponse>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
    }
}
