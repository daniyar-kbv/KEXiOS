//
//  AddressPickerCellViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

public protocol AddressPickerCellViewModelProtocol: AnyObject {
    var name: BehaviorRelay<String?> { get }
    var isSelected: BehaviorRelay<Bool> { get }
}

public final class AddressPickerCellViewModel: AddressPickerCellViewModelProtocol {
    public var name: BehaviorRelay<String?>
    public var isSelected: BehaviorRelay<Bool>

    public init(deliveryAddress: DeliveryAddress,
                isSelected: Bool)
    {
        name = .init(value: deliveryAddress.address?.name)
        self.isSelected = .init(value: isSelected)
    }
}
