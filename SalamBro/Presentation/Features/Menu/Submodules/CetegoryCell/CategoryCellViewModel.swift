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
    public var router: Router
    public var categoryTitle: BehaviorRelay<String?>

    public init(router: Router,
                category: FoodTypeUI)
    {
        self.router = router
        categoryTitle = .init(value: category.title)
    }
}
