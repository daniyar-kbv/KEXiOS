//
//  Countr.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

public protocol CountryCodeCellViewModelProtocol: ViewModel {
    var title: BehaviorRelay<String?> { get }
    var code: BehaviorRelay<String?> { get }
    var isSelected: BehaviorRelay<Bool> { get }
}

public final class CountryCodeCellViewModel: CountryCodeCellViewModelProtocol {
    public var title: BehaviorRelay<String?>
    public var code: BehaviorRelay<String?>
    public var isSelected: BehaviorRelay<Bool>

    public init(country: CountryUI, isSelected: Bool) {
        title = .init(value: country.name)
        code = .init(value: country.callingCode)
        self.isSelected = .init(value: isSelected)
    }
}
