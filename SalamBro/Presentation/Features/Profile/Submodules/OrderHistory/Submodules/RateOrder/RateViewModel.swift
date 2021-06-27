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

    private(set) var data: [String] = []

    private(set) var arrayStar13: [String] = [L10n.RateOrder.Cell.CourierWork.text, L10n.RateOrder.Cell.GivenTime.text, L10n.RateOrder.Cell.CourierNotFoundClient.text, L10n.RateOrder.Cell.FoodIsMissing.text, L10n.RateOrder.Cell.FoodIsCold.text]
    private(set) var arrayStar4: [String] = [L10n.RateOrder.Cell.CourierWork.text, L10n.RateOrder.Cell.GivenTime.text, L10n.RateOrder.Cell.DeliveryTime.text, L10n.RateOrder.Cell.FoodIsCold.text]
    private(set) var arrayStar5: [String] = [L10n.RateOrder.Cell.CourierWork.text, L10n.RateOrder.Cell.GivenTime.text, L10n.RateOrder.Cell.DeliveryTime.text]

    private(set) var selectedItems: [String] = []

    init() {}

    func changeDataSet(with array: [String]) {
        data = array
    }

    func condigureSelectedChoices(with choice: String) {
        selectedItems.append(choice)
    }

    func deleteSelectedChoice(at index: Int) {
        selectedItems.remove(at: index)
    }
}

extension RateViewModel {}
