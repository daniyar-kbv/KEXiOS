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

    init(promotions: [PromotionsResponse.ResponseData.Promotion]) {
        cellViewModels = promotions.map { AdCellViewModel(promotion: $0) }
    }
}
