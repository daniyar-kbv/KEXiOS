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
            let lastAddress = try? outputs.selectedAddress.value()
            lastAddress?.comment = comment
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
         userAddress: UserAddress)
    {
        self.defaultStorage = defaultStorage
        self.addressRepository = addressRepository
        self.brandRepository = brandRepository

        self.flow = flow

        if let addressLatitude = userAddress.address.latitude,
           let addressLongitude = userAddress.address.longitude
        {
            targetLocation = YMKPoint(latitude: addressLatitude,
                                      longitude: addressLongitude)
        } else if let city = userAddress.address.city {
            targetLocation = YMKPoint(latitude: city.latitude,
                                      longitude: city.longitude)
        } else {
            targetLocation = YMKPoint(latitude: Constants.Map.Coordinates.ALA_LAT,
                                      longitude: Constants.Map.Coordinates.ALA_LON)
        }

        outputs.selectedAddress.onNext(userAddress.address)
        commentary = userAddress.address.comment
    }

    func onActionButtonTapped() {
        guard let lastAddress = try? outputs.selectedAddress.value() else { return }
        switch flow {
        case .creation:
            addressRepository.changeCurrentAddress(district: lastAddress.district, street: lastAddress.street, building: lastAddress.building, corpus: lastAddress.corpus, flat: lastAddress.flat, comment: commentary, longitude: lastAddress.longitude, latitude: lastAddress.latitude)
            bindToOrdersOutputs(using: lastAddress)
            guard let userAddress = addressRepository.getCurrentUserAddress() else { return }
            addressRepository.setInitial(userAddress: userAddress)
        case .change:
            outputs.lastSelectedAddress.accept(lastAddress)
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
            guard let _ = searchResult.obj!.geometry.first?.point else { return }
            guard let objectMetadata = (response.collection.children[0].obj!.metadataContainer.getItemOf(YMKSearchToponymObjectMetadata.self) as? YMKSearchToponymObjectMetadata) else { continue }
            let addressComponenets = objectMetadata.address.components

//            Tech debt: process addresses without street or district
//            YMKSearchComponentKind.house

            let district = addressComponenets
                .first(where: {
                    $0.kinds.contains(Constants.Map.ComponentsKinds.district)
                })?
                .name
            let street = addressComponenets
                .first(where: {
                    $0.kinds.contains(Constants.Map.ComponentsKinds.street)
                })?
                .name
            let building = addressComponenets
                .first(where: {
                    $0.kinds.contains(Constants.Map.ComponentsKinds.building)
                })?
                .name

            let address = Address()
            address.district = district
            address.street = street
            address.building = building
            address.longitude = objectMetadata.balloonPoint.longitude
            address.latitude = objectMetadata.balloonPoint.latitude

            outputs.selectedAddress.onNext(address)

            if shouldMoveMap {
                outputs.moveMapTo.accept(YMKPoint(latitude: objectMetadata.balloonPoint.longitude,
                                                  longitude: objectMetadata.balloonPoint.latitude))
            }

            return
        }
    }
}

extension MapViewModel {
    private func bindToOrdersOutputs(using address: Address) {
        addressRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        addressRepository.outputs.didSaveUserAddress
            .subscribe(onNext: { [weak self] in
                self?.outputs.lastSelectedAddress.accept(address)
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
        let selectedAddress = BehaviorSubject<Address?>(value: nil)
        let lastSelectedAddress = PublishRelay<Address>()
        let updateComment = PublishRelay<String>()

        let didGetError = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didFinishRequest = PublishRelay<Void>()
    }
}
