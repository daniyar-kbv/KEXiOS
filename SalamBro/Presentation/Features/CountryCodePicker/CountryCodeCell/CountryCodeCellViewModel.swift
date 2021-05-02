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
}

public final class CountryCodeCellViewModel: CountryCodeCellViewModelProtocol {
    public var title: BehaviorRelay<String?>

    public init(country: CountryUI) {
        title = .init(value: country.name + "   " + country.callingCode)
    }
}
