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

    private let ordersService: OrdersService
    private let defaultStorage: DefaultStorage
    private let locationRepository: LocationRepository
    private let brandRepository: BrandRepository

    let outputs = Output()
    var currentLocation: YMKPoint?
    var targetLocation: YMKPoint
    var commentary: String?

    private let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .online)
    private var searchSession: YMKSearchSession?
    private(set) var flow: MapFlow
    private let disposeBag = DisposeBag()

    init(ordersService: OrdersService,
         defaultStorage: DefaultStorage,
         locationRepository: LocationRepository,
         brandRepository: BrandRepository,
         flow: MapFlow,
         address: Address? = nil)
    {
        self.ordersService = ordersService
        self.defaultStorage = defaultStorage
        self.locationRepository = locationRepository
        self.brandRepository = brandRepository

        self.flow = flow
        targetLocation = YMKPoint(latitude: address?.latitude ?? ALA_LAT,
                                  longitude: address?.longitude ?? ALA_LON)
        outputs.selectedAddress
            .onNext(MapAddress(name: address?.name ?? "",
                               formattedAddress: address?.name ?? "",
                               longitude: address?.longitude ?? 0,
                               latitude: address?.latitude ?? 0))
        commentary = address?.commentary
    }

    func onActionButtonTapped() {
        guard let lastAddress = try? outputs.selectedAddress.value() else { return }
        switch flow {
        case .creation:
            locationRepository.changeCurrentAddress(to: Address(name: lastAddress.name, longitude: lastAddress.longitude, latitude: lastAddress.latitude))
//            Tech debt: uncomment when orders applu api stabilize
            applyOrders(address: lastAddress)
//            defaultStorage.persist(leadUUID: "ace65478-c4ba-4a78-84a8-26c49466244c")
//            outputs.lastSelectedAddress.accept(lastAddress)
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
            if let _ = searchResult.obj!.geometry.first?.point {
                guard let objMetadata = response.collection.children[0].obj!.metadataContainer.getItemOf(YMKSearchToponymObjectMetadata.self) as? YMKSearchToponymObjectMetadata else {
                    continue
                }

                guard
                    let name = searchResult.obj?.name
                else { return }
                let address = MapAddress(name: name,
                                         formattedAddress: objMetadata.address.formattedAddress,
                                         longitude: objMetadata.balloonPoint.longitude,
                                         latitude: objMetadata.balloonPoint.latitude)
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
    func applyOrders(address: MapAddress) {
        guard let brandId = brandRepository.getCurrentBrand()?.id,
              let cityId = locationRepository.getCurrectCity()?.id,
              let longitude = locationRepository.getCurrentAddress()?.longitude.rounded(to: 8),
              let latitude = locationRepository.getCurrentAddress()?.latitude.rounded(to: 8) else { return }

        let dto: OrderApplyDTO = .init(address: .init(city: cityId,
                                                      longitude: longitude,
                                                      latitude: latitude),
                                       localBrand: brandId)

        outputs.didStartRequest.accept(())

        ordersService.applyOrder(dto: dto)
            .subscribe { [weak self] leadUUID in
                self?.outputs.didFinishRequest.accept(())
                self?.defaultStorage.persist(leadUUID: leadUUID)
                self?.outputs.lastSelectedAddress.accept(address)
            } onError: { [weak self] error in
                self?.outputs.didFinishRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didGetError.accept(error)
            }.disposed(by: disposeBag)
    }
}

extension MapViewModel {
    struct Output {
        let moveMapTo = PublishRelay<YMKPoint>()
        let selectedAddress = BehaviorSubject<MapAddress>(value: MapAddress(name: "", formattedAddress: "", longitude: 0, latitude: 0))
        let lastSelectedAddress = PublishRelay<MapAddress>()

        let didGetError = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didFinishRequest = PublishRelay<Void>()
    }
}
