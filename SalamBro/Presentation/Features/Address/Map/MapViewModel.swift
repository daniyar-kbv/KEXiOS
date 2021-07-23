//
//  MapViewModel.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 02.06.2021.
//

import Foundation
import RxCocoa
import RxSwift
import YandexMapKit
import YandexMapKitSearch

final class MapViewModel {
    enum MapFlow {
        case creation
        case change
    }

    private let defaultStorage: DefaultStorage
    private let addressRepository: AddressRepository
    private let brandRepository: BrandRepository

    let outputs = Output()
    var currentLocation: YMKPoint?
    var targetLocation: YMKPoint
    var commentary: String? {
        didSet {
            guard let comment = commentary else { return }
            outputs.updateComment.accept(comment)
        }
    }

    private let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .online)
    private var searchSession: YMKSearchSession?
    private(set) var flow: MapFlow
    private let disposeBag = DisposeBag()

    init(defaultStorage: DefaultStorage,
         addressRepository: AddressRepository,
         brandRepository: BrandRepository,
         flow: MapFlow,
         address: Address? = nil)
    {
        self.defaultStorage = defaultStorage
        self.addressRepository = addressRepository
        self.brandRepository = brandRepository

        self.flow = flow
        targetLocation = YMKPoint(latitude: address?.latitude ?? Constants.Map.Coordinates.ALA_LAT,
                                  longitude: address?.longitude ?? Constants.Map.Coordinates.ALA_LON)

        if let address = address {
            outputs.selectedAddress.onNext(address)
            commentary = address.comment
        }
    }

    func onActionButtonTapped() {
        guard let lastAddress = try? outputs.selectedAddress.value() else { return }
        switch flow {
        case .creation:
            addressRepository.changeCurrentAddress(to: lastAddress)
            bindToOrdersOutputs(using: lastAddress)
            addressRepository.applyOrder()
        case .change:
            outputs.lastSelectedAddress.accept((lastAddress, commentary))
        }
    }

    func reverseGeoCoding(searchQuery: String, title _: String) {
        let responseHandler = { [weak self] (searchResponse: YMKSearchResponse?, _: Error?) -> Void in
            guard let response = searchResponse else { return }
            self?.onSearchResponseName(response, shouldMoveMap: true)
        }

        searchSession = searchManager.submit(withText: searchQuery, geometry: YMKGeometry(point: targetLocation), searchOptions: YMKSearchOptions(), responseHandler: responseHandler)
    }

    func getName(point: YMKPoint, zoom: NSNumber) {
        let responseHandler = { (searchResponse: YMKSearchResponse?, _: Error?) -> Void in
            if let response = searchResponse {
                self.onSearchResponseName(response)
            }
        }
        searchSession = searchManager.submit(with: point, zoom: zoom, searchOptions: YMKSearchOptions(), responseHandler: responseHandler)
    }

    private func onSearchResponseName(_ response: YMKSearchResponse, shouldMoveMap: Bool = false) {
        for searchResult in response.collection.children {
            if let _ = searchResult.obj!.geometry.first?.point {
                guard let objMetadata = response.collection.children[0].obj!.metadataContainer.getItemOf(YMKSearchToponymObjectMetadata.self) as? YMKSearchToponymObjectMetadata else {
                    continue
                }

                guard
                    let name = searchResult.obj?.name
                else { return }
//                TODO: change
                let address = Address(id: nil, district: nil, street: nil, building: nil, corpus: nil, flat: nil, comment: nil, country: nil, city: 0, longitude: 0, latitude: 0)
                outputs.selectedAddress.onNext(address)

                if shouldMoveMap {
                    outputs.moveMapTo.accept(YMKPoint(latitude: address.latitude, longitude: address.longitude))
                }

                return
            }
        }
    }
}

extension MapViewModel {
    private func bindToOrdersOutputs(using address: Address) {
        addressRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        addressRepository.outputs.didGetLeadUUID
            .subscribe(onNext: { [weak self] in
                self?.outputs.lastSelectedAddress.accept((address, self?.commentary))
            })
            .disposed(by: disposeBag)

        addressRepository.outputs.didEndRequest
            .bind(to: outputs.didFinishRequest)
            .disposed(by: disposeBag)

        addressRepository.outputs.didFail
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)
    }
}

extension MapViewModel {
    struct Output {
        let moveMapTo = PublishRelay<YMKPoint>()
        let selectedAddress = BehaviorSubject<Address>(value: .init(id: nil, district: nil, street: nil, building: nil, corpus: nil, flat: nil, comment: nil, country: nil, city: 0, longitude: 0, latitude: 0))
        let lastSelectedAddress = PublishRelay<(Address, String?)>()
        let updateComment = PublishRelay<String>()

        let didGetError = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didFinishRequest = PublishRelay<Void>()
    }
}
