//
//  ProfileRepository.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 24.06.2021.
//

import Foundation
import RxCocoa
import RxSwift
import WebKit

protocol ProfileRepository: AnyObject {
    var outputs: ProfileRepositoryImpl.Output { get }
    func fetchUserInfo()
    func set(userInfo: UserInfoResponse)
    func changeUserInfo(name: String?, email: String?)
    func logout()
    func userDidAuthenticate() -> Bool
}

final class ProfileRepositoryImpl: ProfileRepository {
    private let disposeBag = DisposeBag()

    private(set) var outputs: Output = .init()

    private let profileService: ProfileService
    private let authService: AuthService
    private let tokenStorage: AuthTokenStorage
    private let defaultStorage: DefaultStorage

    init(profileService: ProfileService, authService: AuthService, tokenStorage: AuthTokenStorage, defaultStorage: DefaultStorage) {
        self.profileService = profileService
        self.authService = authService
        self.tokenStorage = tokenStorage
        self.defaultStorage = defaultStorage

        bindNotifications()
    }

    func fetchUserInfo() {
        outputs.didStartRequest.accept(())
        profileService.getUserInfo()
            .retryWhenUnautharized()
            .subscribe(onSuccess: { [weak self] userResponse in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didGetUserInfo.accept(userResponse)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didFail.accept(error)
            })
            .disposed(by: disposeBag)
    }

    func logout() {
        guard let token = defaultStorage.fcmToken else { return }

        outputs.didStartRequest.accept(())
        profileService.logOutUser(dto: LogOutDTO(token: token))
            .retryWhenUnautharized()
            .subscribe(onSuccess: { [weak self] _ in
                self?.outputs.didEndRequest.accept(())
                self?.logoutWhenUnauthorized()
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                if (error as? NetworkError) == .unauthorized {
                    self?.logoutWhenUnauthorized()
                    return
                }
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didFail.accept(error)
            })
            .disposed(by: disposeBag)
    }

    func logoutWhenUnauthorized() {
        tokenStorage.cleanUp()
        clearCookies()
        outputs.didLogout.accept(())
    }

    func set(userInfo: UserInfoResponse) {
        outputs.didGetUserInfo.accept(userInfo)
    }

    func changeUserInfo(name: String?, email: String?) {
        outputs.didStartRequest.accept(())
        profileService.updateUserInfo(with: UserInfoDTO(name: name, email: email, mobilePhone: nil))
            .retryWhenUnautharized()
            .subscribe(onSuccess: { [weak self] userInfo in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didGetUserInfo.accept(userInfo)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                if let error = error as? ErrorPresentable {
                    self?.outputs.didFail.accept(error)
                }
            })
            .disposed(by: disposeBag)
    }

    func userDidAuthenticate() -> Bool {
        guard let _ = tokenStorage.token else { return false }
        return true
    }
}

extension ProfileRepositoryImpl {
    private func bindNotifications() {
        NotificationCenter.default.rx
            .notification(Constants.InternalNotification.userInfo.name)
            .subscribe(onNext: { [weak self] in
                guard let userInfo = $0.object as? UserInfoResponse else { return }
                self?.outputs.didGetUserInfo.accept(userInfo)
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(Constants.InternalNotification.unauthorize.name)
            .subscribe(onNext: { [weak self] _ in
                self?.logoutWhenUnauthorized()
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(Constants.InternalNotification.updateProfile.name)
            .subscribe(onNext: { [weak self] _ in
                guard self?.tokenStorage.token != nil else { return }
                self?.fetchUserInfo()
            })
            .disposed(by: disposeBag)
    }

    private func clearCookies() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                                 for: records,
                                 completionHandler: {})
        }
    }
}

extension ProfileRepositoryImpl {
    struct Output {
        let didGetUserInfo = PublishRelay<UserInfoResponse>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didLogout = PublishRelay<Void>()
    }
}
