//
//  RateViewModel.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/18/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol RateViewModelProtocol: AnyObject {}

final class RateViewModel: RateViewModelProtocol {
    private let disposeBag = DisposeBag()

    public var data: [String] = []

    public let arrayStar13: [String] = [L10n.RateOrder.Cell.CourierWork.text, L10n.RateOrder.Cell.GivenTime.text, L10n.RateOrder.Cell.CourierNotFoundClient.text, L10n.RateOrder.Cell.FoodIsMissing.text, L10n.RateOrder.Cell.FoodIsCold.text]
    public let arrayStar4: [String] = [L10n.RateOrder.Cell.CourierWork.text, L10n.RateOrder.Cell.GivenTime.text, L10n.RateOrder.Cell.DeliveryTime.text, L10n.RateOrder.Cell.FoodIsCold.text]
    public let arrayStar5: [String] = [L10n.RateOrder.Cell.CourierWork.text, L10n.RateOrder.Cell.GivenTime.text, L10n.RateOrder.Cell.DeliveryTime.text]

    public var selectedItems: [String] = []

    init() {}
}

extension RateViewModel {}
