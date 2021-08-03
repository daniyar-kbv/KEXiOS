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
    var currentUserInfo: UserInfoResponse? { get }

    func fetchUserInfo()
    func logout()
    func set(userInfo: UserInfoResponse)
    func userDidAuthenticate() -> Bool
}

final class ProfileViewModelImpl: ProfileViewModel {
    private let disposeBag = DisposeBag()
    private(set) var tableItems: [ProfileTableItem] = [
        .orderHistory,
        .changeLanguage,
        .deliveryAddress,
    ]

    private(set) var outputs: Output = .init()
    private(set) var currentUserInfo: UserInfoResponse?

    private let repository: ProfileRepository

    init(repository: ProfileRepository) {
        self.repository = repository
        bindOutputs()
    }

    func fetchUserInfo() {
        repository.fetchUserInfo()
    }

    func logout() {
        repository.logout()
    }

    func set(userInfo: UserInfoResponse) {
        repository.set(userInfo: userInfo)
    }

    func userDidAuthenticate() -> Bool {
        repository.userDidAuthenticate()
    }

    private func bindOutputs() {
        repository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        repository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        repository.outputs.didFail
            .bind(to: outputs.didFail)
            .disposed(by: disposeBag)

        repository.outputs.didGetUserInfo
            .bind(to: outputs.didGetUserInfo)
            .disposed(by: disposeBag)

        repository.outputs.didGetUserInfo
            .bind { [weak self] userInfo in
                self?.currentUserInfo = userInfo
            }
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
