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
    var outputs: PushNotificationsRepositoryImpl.Output { get }

    func tokenUpdate(fcmToken: String)
}

final class PushNotificationsRepositoryImpl: PushNotificationsRepository {
    private let disposeBag = DisposeBag()
    private let notificationsService: PushNotificationsService
    private let defaultStorage: DefaultStorage
    private let authTokenStorage: AuthTokenStorage

    let outputs = Output()

    init(notificationsService: PushNotificationsService,
         defaultStorage: DefaultStorage,
         authTokenStorage: AuthTokenStorage)
    {
        self.notificationsService = notificationsService
        self.defaultStorage = defaultStorage
        self.authTokenStorage = authTokenStorage
    }

    func tokenUpdate(fcmToken: String) {
        guard fcmToken != defaultStorage.fcmToken else { return }

        defaultStorage.persist(fcmToken: fcmToken)

        guard authTokenStorage.token != nil else { return }

        let dto = FCMTokenUpdateDTO(fcmToken: fcmToken)

        notificationsService.fcmTokenUpdate(dto: dto)
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension PushNotificationsRepositoryImpl {
    struct Output {}
}
