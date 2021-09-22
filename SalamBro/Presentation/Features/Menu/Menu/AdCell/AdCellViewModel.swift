//
//  AdCellViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol AdCellViewModelProtocol: ViewModel {
    var promotion: Promotion { get }
    var promotionImageURL: BehaviorRelay<String?> { get }
}

final class AdCellViewModel: AdCellViewModelProtocol {
    let promotion: Promotion

    let promotionImageURL: BehaviorRelay<String?>

    init(promotion: Promotion) {
        self.promotion = promotion

        promotionImageURL = .init(value: promotion.imageSmall)
    }
}
