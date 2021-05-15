//
//  AddressPickCellViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

public protocol AddressPickCellViewModelProtocol: ViewModel {
    var address: BehaviorRelay<String?> { get }
}

public final class AddressPickCellViewModel: AddressPickCellViewModelProtocol {
    public var router: Router
    public var address: BehaviorRelay<String?>
    public init(router: Router,
                address: Address?)
    {
        self.router = router
        self.address = .init(value: address?.name)
    }
}
