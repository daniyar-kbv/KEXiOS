//
//  SetNameViewModel.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 31.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol SetNameViewModel: AnyObject {
    var outputs: SetNameViewModelImpl.Output { get }
    func persist(name: String)
}

final class SetNameViewModelImpl: SetNameViewModel {
    let outputs: Output = .init()

    private let disposeBag = DisposeBag()

    private let repository: ProfileRepository

    init(repository: ProfileRepository) {
        self.repository = repository
        bindOutputs()
    }

    func persist(name: String) {
        repository.changeUserInfo(name: name, email: nil)
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
            .bind { [weak self] _ in
                self?.outputs.didSaveUserName.accept(())
            }
            .disposed(by: disposeBag)
    }
}

extension SetNameViewModelImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didSaveUserName = PublishRelay<Void>()
    }
}
