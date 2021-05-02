//
//  CategoryCellViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import RxSwift
import RxCocoa

public protocol CategoryCellViewModelProtocol: ViewModel {
    var categoryTitle: BehaviorRelay<String?> { get }
}

public final class CategoryCellViewModel: CategoryCellViewModelProtocol {
    public var categoryTitle: BehaviorRelay<String?>
    
    public init(category: FoodType) {
        self.categoryTitle = .init(value: category.title)
    }
}
