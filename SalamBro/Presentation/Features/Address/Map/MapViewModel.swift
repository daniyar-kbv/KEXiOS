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

    private let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
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
            targetLocation = YMKPoint(latitude: Constants.Map.Coordinates.ALALatitude,
                                      longitude: Constants.Map.Coordinates.ALALongitude)
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

    func straightGeocoding(searchQuery: String, title _: String) {
        let responseHandler: (_ searchResponse: YMKSearchResponse?, _: Error?) -> Void = { [weak self] response, _ in
            guard let response = response else { return }
            self?.onSearchResponseName(response, shouldMoveMap: true)
        }
        searchSession = searchManager.submit(withText: searchQuery,
                                             geometry: YMKGeometry(point: targetLocation),
                                             searchOptions: YMKSearchOptions(),
                                             responseHandler: responseHandler)
    }

    func reverseGeocoding(point: YMKPoint, zoom: NSNumber) {
        let responseHandler: (_ searchResponse: YMKSearchResponse?, _: Error?) -> Void = { [weak self] response, _ in
            guard let response = response else { return }
            self?.onSearchResponseName(response, shouldMoveMap: false)
        }
        searchSession = searchManager.submit(with: point,
                                             zoom: zoom,
                                             searchOptions: YMKSearchOptions(),
                                             responseHandler: responseHandler)
    }

    private func onSearchResponseName(_ response: YMKSearchResponse, shouldMoveMap: Bool = false) {
        guard let objectMetadata = response.collection.children.first?.obj?.metadataContainer
            .getItemOf(YMKSearchToponymObjectMetadata.self) as? YMKSearchToponymObjectMetadata
        else { return }

        var address = Address()

        construct(address: &address, with: objectMetadata.address.components)

        address.longitude = objectMetadata.balloonPoint.longitude
        address.latitude = objectMetadata.balloonPoint.latitude

        outputs.selectedAddress.onNext(address)

        if shouldMoveMap {
            outputs.moveMapTo.accept(YMKPoint(latitude: objectMetadata.balloonPoint.latitude,
                                              longitude: objectMetadata.balloonPoint.longitude))
        }
    }

    private func construct(address: inout Address, with components: [YMKSearchAddressComponent]) {
        var street: String?
        var district: String?
        var locality: String?
        var building: String?

        components.forEach { component in
            component.kinds.forEach { kind in
                switch resolveKind(of: kind) {
                case .street: street = component.name
                case .district: district = component.name
                case .locality: locality = component.name
                case .house: building = component.name
                default: break
                }
            }
        }

        guard building != nil else { return }
        address.building = building

        if street != nil {
            address.street = street
            if district != nil {
                address.district = district
            }
        } else if district != nil {
            address.district = district
        } else if locality != nil {
            address.district = locality
        } else {
            return
        }
    }

    private func resolveKind(of kind: NSNumber) -> YMKSearchComponentKind {
        return YMKSearchComponentKind(rawValue: .init(truncating: kind)) ?? .unknown
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
