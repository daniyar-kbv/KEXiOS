//
//  DeliveryChangedError.swift
//  SalamBro
//
//  Created by Dan on 2021-12-05.
//

import Foundation
import Moya
import RxCocoa
import RxSwift
import WebKit

private var _ordersProvider: MoyaProvider<OrdersAPI>?
private var _authApplyProvider: MoyaProvider<OrdersAPI>?
private var _geoStorage: GeoStorage?
private let disposeBag = DisposeBag()

extension Single {
    static var ordersProvider: MoyaProvider<OrdersAPI>? {
        get {
            _ordersProvider
        }
        set {
            _ordersProvider = newValue
        }
    }

    static var authApplyProvider: MoyaProvider<OrdersAPI>? {
        get {
            _authApplyProvider
        }
        set {
            _authApplyProvider = newValue
        }
    }

    static var geoStorage: GeoStorage? {
        get {
            _geoStorage
        }
        set {
            _geoStorage = newValue
        }
    }

    private var authTokenStorage: AuthTokenStorage {
        return AuthTokenStorageImpl.sharedStorage
    }

    private var defaultStorage: DefaultStorage {
        return DefaultStorageImpl.sharedStorage
    }

    private func map(response: Response) throws {
        guard let applyResponse = try? response.map(OrderApplyResponse.self) else {
            throw NetworkError.badMapping
        }

        if let error = applyResponse.error {
            throw error
        }

        guard let leadUUID = applyResponse.data?.uuid else {
            throw NetworkError.noData
        }

        defaultStorage.persist(leadUUID: leadUUID)
    }

    private func updateLead() throws -> Single<Void> {
        if authTokenStorage.token == nil,
           let ordersProvider = Single<Any>.ordersProvider,
           let dto = Single<Any>.geoStorage?.userAddresses.first(where: { $0.isCurrent })?.toDTO()
        {
            return ordersProvider.rx
                .request(.apply(dto: dto))
                .map { try? map(response: $0) }
        } else if authTokenStorage.token != nil,
                  let authApplyProvider = Single<Any>.authApplyProvider
        {
            return authApplyProvider.rx
                .request(.authorizedApply(dto: nil))
                .map { try? map(response: $0) }
        }

        throw NetworkError.noData
    }

    func retryWhenDeliveryChanged() -> PrimitiveSequence<Trait, Element> {
        return retryWhen { source in
            source.flatMapLatest { error -> Single<Void> in
                if let error = error as? MoyaError {
                    switch error {
                    case let .underlying(error, _):
                        if let error = error as? NetworkError,
                           error == .deliveryChanged
                        {
                            do {
                                let test = try updateLead()
                                return test
                            } catch {
                                throw error
                            }
                        }
                    default: break
                    }
                }

                return Single.error(error)
            }
        }
    }
}
