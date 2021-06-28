//
//  RateViewModel.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/18/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol RateViewModel: AnyObject {
    var choices: [RateItem] { get }
    var currentChoices: [RateItem] { get }

    func getRateItem(at index: Int) -> RateItem
    func changeDataSet(by rating: Int)
    func condigureDataSet(at index: Int)
}

final class RateViewModelImpl: RateViewModel {
    private let disposeBag = DisposeBag()

    private(set) var currentChoices: [RateItem] = []

    private(set) var choices: [RateItem] = [RateItem(title: .notFound, isSelected: false), RateItem(title: .foodIsMissing, isSelected: false), RateItem(title: .foodIsCold, isSelected: false), RateItem(title: .courierWork, isSelected: false), RateItem(title: .givenTime, isSelected: false), RateItem(title: .deliveryTime, isSelected: false)]

    init() {}

    func getRateItem(at index: Int) -> RateItem {
        return currentChoices[index]
    }

    func changeDataSet(by rating: Int) {
        switch rating {
        case 3:
            currentChoices = Array(choices[0 ... 4])
        case 4:
            currentChoices = Array(choices[2 ... 5])
        case 5:
            currentChoices = Array(choices[3 ... 5])
        default:
            break
        }
    }

    func condigureDataSet(at index: Int) {
        for i in 0 ..< choices.count {
            if choices[i].title == currentChoices[index].title {
                currentChoices[index].isSelected.toggle()
                choices[i].isSelected.toggle()
            }
        }
    }
}
