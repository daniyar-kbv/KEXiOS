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
}

extension PushNotificationsRepositoryImpl {
    struct Output {}
}
