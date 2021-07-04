//
//  ChangeNameViewModel.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 16.06.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol ChangeNameViewModel: AnyObject {
    var outputs: ChangeNameViewModelImpl.Output { get }
    var oldUserInfo: UserInfoResponse { get }
    func change(name: String?, email: String?)
}

final class ChangeNameViewModelImpl: ChangeNameViewModel {
    private let disposeBag = DisposeBag()

    private(set) var outputs: Output = .init()

    private let repository: ChangeUserInfoRepository
    private(set) var oldUserInfo: UserInfoResponse

    init(repository: ChangeUserInfoRepository, userInfo: UserInfoResponse) {
        self.repository = repository
        oldUserInfo = userInfo
        bindOutputs()
    }

    func change(name: String?, email: String?) {
        repository.change(name: name, email: email)
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
            .bind { [weak self] userInfo in
                self?.outputs.didGetUserInfo.accept(userInfo)
            }
            .disposed(by: disposeBag)
    }
}

extension ChangeNameViewModelImpl {
    struct Output {
        let didGetUserInfo = PublishRelay<UserInfoResponse>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
    }
}
