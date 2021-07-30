//
//  AddressPickerCellViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol AddressPickerCellViewModelProtocol: AnyObject {
    var name: BehaviorRelay<String?> { get }
    var isSelected: BehaviorRelay<Bool> { get }
}

final class AddressPickerCellViewModel: AddressPickerCellViewModelProtocol {
    public var name: BehaviorRelay<String?>
    public var isSelected: BehaviorRelay<Bool>

    init(userAddress: UserAddress,
         isSelected: Bool)
    {
        name = .init(value: userAddress.address.getName())
        self.isSelected = .init(value: isSelected)
    }
}
