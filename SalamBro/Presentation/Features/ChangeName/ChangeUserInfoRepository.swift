//
//  ChangeNameRepository.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/4/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol ChangeUserInfoRepository: AnyObject {
    var outputs: ChangeUserInfoRepositoryImpl.Output { get }

    func changeUserInfo(name: String?, email: String?)
    func saveUserName(with name: String)
}

final class ChangeUserInfoRepositoryImpl: ChangeUserInfoRepository {
    private let disposeBag = DisposeBag()

    private(set) var outputs: Output = .init()

    private let service: ProfileService
    private let defaultStorage: DefaultStorage

    init(service: ProfileService, defaultStorage: DefaultStorage) {
        self.service = service
        self.defaultStorage = defaultStorage
    }

    func changeUserInfo(name: String?, email: String?) {
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

    func saveUserName(with name: String) {
        outputs.didStartRequest.accept(())
        service.updateUserInfo(with: UserInfoDTO(name: name, email: nil, mobilePhone: nil))
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

extension ChangeUserInfoRepositoryImpl {
    struct Output {
        let didGetUserInfo = PublishRelay<UserInfoResponse>()
        let didSaveUserName = PublishRelay<UserInfoResponse>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
    }
}
