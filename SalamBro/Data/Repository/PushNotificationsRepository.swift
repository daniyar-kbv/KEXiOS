//
//  NotificationsRepository.swift
//  SalamBro
//
//  Created by Dan on 7/17/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol PushNotificationsRepository: AnyObject {
    func process(fcmToken: String)
}

final class PushNotificationsRepositoryImpl: PushNotificationsRepository {
    private let disposeBag = DisposeBag()
    private let notificationsService: PushNotificationsService
    private let defaultStorage: DefaultStorage

    init(notificationsService: PushNotificationsService,
         defaultStorage: DefaultStorage)
    {
        self.notificationsService = notificationsService
        self.defaultStorage = defaultStorage
    }

    func process(fcmToken: String) {
        guard let oldFcmToken = defaultStorage.fcmToken
        else {
            defaultStorage.persist(fcmToken: fcmToken)
            fcmTokenSave(fcmToken: fcmToken)
            return
        }

        guard oldFcmToken != fcmToken else { return }

        fcmTokenUpdate(newToken: fcmToken)
    }

    private func fcmTokenSave(fcmToken: String) {
        notificationsService
            .fcmTokenSave(dto: .init(fcmToken: fcmToken))
            .retryWhenUnautharized()
            .subscribe()
            .disposed(by: disposeBag)
    }

    private func fcmTokenUpdate(newToken: String) {
        guard let oldFcmToken = defaultStorage.fcmToken else { return }
        defaultStorage.persist(fcmToken: newToken)
        notificationsService
            .fcmTokenUpdate(dto: .init(oldFCMToken: oldFcmToken, newFCMToken: newToken))
            .retryWhenUnautharized()
            .subscribe()
            .disposed(by: disposeBag)
    }
}
