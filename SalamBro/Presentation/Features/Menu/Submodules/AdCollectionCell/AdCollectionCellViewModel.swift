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
    var cellViewModels: [AdCellViewModelProtocol]

    init(ads: [PromotionsResponse.ResponseData.Promotion]) {
        cellViewModels = ads.map { AdCellViewModel(ad: $0) }
    }
}
