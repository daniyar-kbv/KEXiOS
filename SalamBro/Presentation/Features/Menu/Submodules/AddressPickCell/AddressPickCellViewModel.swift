//
//  AddressPickCellViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol AddressPickCellViewModelProtocol: ViewModel {
    var address: BehaviorRelay<String?> { get }
}

final class AddressPickCellViewModel: AddressPickCellViewModelProtocol {
    var address: BehaviorRelay<String?>
    
    init(address: Address?) {
        self.address = .init(value: address?.name)
    }
}
