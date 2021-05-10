//
//  AdCollectionCellViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

public protocol AdCollectionCellViewModelProtocol: ViewModel {
    var cellViewModels: [AdCellViewModelProtocol] { get }
}

public final class AdCollectionCellViewModel: AdCollectionCellViewModelProtocol {
    public var router: Router
    public var cellViewModels: [AdCellViewModelProtocol]
    public init(router: Router,
                ads: [AdUI])
    {
        self.router = router
        cellViewModels = ads.map { AdCellViewModel(router: router,
                                                   ad: $0) }
    }
}
