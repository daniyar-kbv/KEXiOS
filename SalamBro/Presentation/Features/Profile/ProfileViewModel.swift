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
    var userInfo: UserInfoResponse? { get }

    func getUserInfo()
    func logout()
}

final class ProfileViewModelImpl: ProfileViewModel {
    private let disposeBag = DisposeBag()
    private(set) var tableItems: [ProfileTableItem] = [
        .orderHistory,
        .changeLanguage,
        .deliveryAddress,
    ]

    private(set) var outputs: Output = .init()
    private(set) var userInfo: UserInfoResponse?

    private let repository: ProfilePageRepository

    init(repository: ProfilePageRepository) {
        self.repository = repository
        bindOutputs()
    }

    func getUserInfo() {
        repository.getUserInfo()
    }

    func logout() {
        repository.logout()
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

        userInfo = repository.userInfo
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
