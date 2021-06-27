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
    func persist(name: String)
    var outputs: SetNameViewModelImpl.Output { get }
}

final class SetNameViewModelImpl: SetNameViewModel {
    let outputs: Output = .init()

    private let disposeBag = DisposeBag()

    private let defaultStorage: DefaultStorage
    private let profileService: ProfileService

    init(defaultStorage: DefaultStorage, profileService: ProfileService) {
        self.defaultStorage = defaultStorage
        self.profileService = profileService
    }

    func persist(name: String) {
        outputs.didStartRequest.accept(())
        profileService.updateUserInfo(with: UserInfoDTO(name: name, email: nil, mobilePhone: nil))
            .subscribe(onSuccess: { [weak self] userInfo in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didSaveUserName.accept(userInfo)
                self?.defaultStorage.persist(name: name)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                if let error = error as? ErrorPresentable {
                    self?.outputs.didFail.accept(error)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SetNameViewModelImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didSaveUserName = PublishRelay<UserInfoResponse>()
    }
}
