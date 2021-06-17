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
    func change(name: String?, email: String?)
    var oldUserInfo: UserInfoResponse { get }
}

final class ChangeNameViewModelImpl: ChangeNameViewModel {
    private let disposeBag = DisposeBag()

    private(set) var outputs: Output = .init()

    private let service: ProfileService
    private let defaultStorage: DefaultStorage
    private(set) var oldUserInfo: UserInfoResponse

    init(service: ProfileService, userInfo: UserInfoResponse, defaultStorage: DefaultStorage) {
        self.service = service
        self.defaultStorage = defaultStorage
        oldUserInfo = userInfo
    }

    func change(name: String?, email: String?) {
        outputs.didStartRequest.accept(())
        service.updateUserInfo(with: UserInfoDTO(name: name, email: email, mobilePhone: nil))
            .subscribe(onSuccess: { [weak self] userInfo in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didGetUserInfo.accept(userInfo)
                if let name = userInfo.name {
                    self?.defaultStorage.persist(name: name)
                }
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                if let error = error as? ErrorPresentable {
                    self?.outputs.didFail.accept(error)
                }
            })
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
