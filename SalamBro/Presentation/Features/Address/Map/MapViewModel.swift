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

    private(set) var flow: MapFlow
    private let disposeBag = DisposeBag()

    private var searchQuery: String?
    private var title: String?
    private var point: YMKPoint?
    private var zoom: NSNumber?

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

        bindOutputs()
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

    func straightGeocoding(searchQuery: String, title: String) {
        self.searchQuery = searchQuery
        self.title = title
        addressRepository.getNearestAddress(geocode: "\(searchQuery)",
                                            language: configureLanguage())
    }

    func reverseGeocoding(point: YMKPoint, zoom: NSNumber) {
        self.point = point
        self.zoom = zoom
        addressRepository.getNearestAddress(geocode: "\(point.latitude), \(point.longitude)",
                                            language: configureLanguage())
    }

    private func configureLanguage() -> String {
        switch defaultStorage.appLocale {
        case .russian, .kazakh: return "ru_RU"
        case .english: return "en_RU"
        }
    }

    private func onSearchResponseName(yandexResponse: YandexResponse) {
        guard let yandexMetadata = yandexResponse.geoObjectCollection.featureMember.first
        else { return }

        var address = Address()

        construct(address: &address, with: yandexMetadata.geoObject.metaDataProperty.geocoderMetaData.address.components)

        let pointsString = yandexMetadata.geoObject.point.pos.split(separator: " ")

        guard let longitude = Double(pointsString[0]), let latitude = Double(pointsString[1]) else { return }
        address.longitude = longitude
        address.latitude = latitude

        outputs.selectedAddress.onNext(address)

        if !isStraightGeocoding(response: yandexResponse) {
            outputs.moveMapTo.accept(YMKPoint(latitude: latitude, longitude: longitude))
        }
    }

    private func construct(address: inout Address, with components: [Component]) {
        var street: String?
        var district: String?
        var locality: String?
        var building: String?

        components.forEach { component in
            switch component.kind {
            case "street": street = component.name
            case "district": district = component.name
            case "locality": locality = component.name
            case "house": building = component.name
            default: break
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
}

extension MapViewModel {
    private func bindOutputs() {
        addressRepository.outputs.didGetNearestAddress
            .subscribe(onNext: { [weak self] address in
                self?.onSearchResponseName(yandexResponse: address)
            })
            .disposed(by: disposeBag)
    }

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

    private func isStraightGeocoding(response: YandexResponse) -> Bool {
        return response.geoObjectCollection.metaDataProperty.geocoderResponseMetaData.point != nil
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
