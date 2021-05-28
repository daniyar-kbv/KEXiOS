//
//  AdCollectionCellViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol AdCollectionCellViewModelProtocol: ViewModel {
    var cellViewModels: [AdCellViewModelProtocol] { get }
}

final class AdCollectionCellViewModel: AdCollectionCellViewModelProtocol {
    var router: Router
    var cellViewModels: [AdCellViewModelProtocol]
    init(router: Router,
         ads: [AdUI])
    {
        self.router = router
        cellViewModels = ads.map { AdCellViewModel(router: router,
                                                   ad: $0) }
    }
}
