//
//  CategoryCellViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

public protocol CategoryCellViewModelProtocol: ViewModel {
    var categoryTitle: BehaviorRelay<String?> { get }
}

public final class CategoryCellViewModel: CategoryCellViewModelProtocol {
    public var categoryTitle: BehaviorRelay<String?>

    public init(category: FoodTypeUI) {
        categoryTitle = .init(value: category.title)
    }
}
