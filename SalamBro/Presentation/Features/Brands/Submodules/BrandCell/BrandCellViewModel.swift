//
//  BrandCellViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

public protocol BrandCellViewModelProtocol: ViewModel {
    var name: BehaviorRelay<String> { get }
}

public final class BrandCellViewModel: BrandCellViewModelProtocol {
    public var name: BehaviorRelay<String>
    public init(brand: BrandUI) {
        name = .init(value: brand.name + brand.priority.description)
    }
}
