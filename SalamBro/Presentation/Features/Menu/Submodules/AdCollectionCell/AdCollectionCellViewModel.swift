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
    public var cellViewModels: [AdCellViewModelProtocol]
    public init(ads: [AdUI]) {
        cellViewModels = ads.map { AdCellViewModel(ad: $0) }
    }
}
