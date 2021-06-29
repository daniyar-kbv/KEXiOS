//
//  SuggestViewModel.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/26/21.
//

import CoreLocation
import RxCocoa
import RxSwift
import UIKit
import YandexMapKitSearch

protocol SuggestViewModel: AnyObject {
    var outputs: SuggestViewModelImpl.Output { get }

    var suggestResults: [YMKSuggestItem] { get }
    var locationManager: CLLocationManager { get }
    var searchManager: YMKSearchManager { get }
    var suggestSession: YMKSearchSuggestSession { get }
    var targetLocation: YMKPoint { get }
    var fullQuery: String { get }

    func getResultAddress(at index: Int) -> YMKSuggestItem
    func search(with query: String)
    func setQuery(with text: String)
}

final class SuggestViewModelImpl: SuggestViewModel {
    private(set) var outputs: Output = .init()

    private(set) var suggestResults: [YMKSuggestItem] = []
    private(set) var locationManager = CLLocationManager()
    private(set) var searchManager: YMKSearchManager = YMKSearch.sharedInstance().createSearchManager(with: .online)
    private(set) var suggestSession: YMKSearchSuggestSession
    private(set) var targetLocation = YMKPoint()
    private(set) var fullQuery: String = ""

    init() {
        suggestSession = searchManager.createSuggestSession()
    }

    func getResultAddress(at index: Int) -> YMKSuggestItem {
        return suggestResults[index]
    }

    func search(with query: String) {
        let suggestHandler = { (response: [YMKSuggestItem]?, error: Error?) -> Void in
            if let items = response {
                self.suggestResults = items
                self.outputs.didEndRequest.accept(())
            } else {
                if let error = error as? ErrorPresentable {
                    self.outputs.didFail.accept(error)
                }
            }
        }
        let point = YMKPoint(latitude: ALA_LAT, longitude: ALA_LON)
        suggestSession.suggest(
            withText: query,
            window: YMKBoundingBox(southWest: point, northEast: point),
            suggestOptions: YMKSuggestOptions(suggestTypes: .geo, userPosition: point, suggestWords: true),
            responseHandler: suggestHandler
        )
    }

    func setQuery(with text: String) {
        fullQuery = text
    }
}

extension SuggestViewModelImpl {
    struct Output {
        let didEndRequest = PublishRelay<Void>()
        let didFail = PublishRelay<ErrorPresentable>()
    }
}
