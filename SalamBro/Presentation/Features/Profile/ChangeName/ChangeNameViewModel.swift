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

    private let repository: ProfileRepository
    private(set) var oldUserInfo: UserInfoResponse

    init(repository: ProfileRepository, userInfo: UserInfoResponse) {
        self.repository = repository
        oldUserInfo = userInfo

        bindOutputs()
    }

    func change(name: String?, email: String?) {
        repository.changeUserInfo(name: name, email: email)
    }

    private func bindOutputs() {
        repository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        repository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        repository.outputs.didFail
            .subscribe(onNext: { [weak self] error in
                if (error as? NetworkError) == .unauthorized {
                    self?.outputs.didFailAuth.accept(error)
                    return
                }
                self?.outputs.didFail.accept(error)
            })
            .disposed(by: disposeBag)

        repository.outputs.didGetUserInfo
            .bind { [weak self] _ in
                self?.outputs.didGetUserInfo.accept(())
            }
            .disposed(by: disposeBag)
    }
}

extension ChangeNameViewModelImpl {
    struct Output {
        let didGetUserInfo = PublishRelay<Void>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didFailAuth = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
    }
}
