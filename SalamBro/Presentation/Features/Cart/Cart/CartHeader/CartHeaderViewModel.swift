//
//  CartHeaderViewModel.swift
//  SalamBro
//
//  Created by Dan on 8/6/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol CartCellViewModel {}

protocol CartHeaderViewModel: CartCellViewModel {
    var outputs: CartHeaderViewModelImpl.Output { get }
}

final class CartHeaderViewModelImpl: CartHeaderViewModel {
    let outputs: Output

    init(type: HeaderType) {
        outputs = .init(fontSize: .init(value: type.fontSize),
                        title: .init(value: type.title))
    }
}

extension CartHeaderViewModelImpl {
    enum HeaderType {
        case positions(count: Int, sum: Double)
        case additional
        case promocode(promocode: String)

        var fontSize: CGFloat {
            switch self {
            case .positions: return 20
            case .additional, .promocode: return 18
            }
        }

        var title: String {
            switch self {
            case let .positions(count, sum):
                switch count {
                case 1:
                    return SBLocalization.localized(key: CartText.Cart.titlePosition, arguments: String(count), sum.formattedWithSeparator)
                case 2 ... 4:
                    return SBLocalization.localized(key: CartText.Cart.titlePositionLessOrEqualFour, arguments: String(count), sum.formattedWithSeparator)
                case 5...:
                    return SBLocalization.localized(key: CartText.Cart.titlePositionGreaterThanFour, arguments: String(count), sum.formattedWithSeparator)
                default:
                    return SBLocalization.localized(key: CartText.Cart.titlePositionGreaterThanFour, arguments: String(count), sum.formattedWithSeparator)
                }
            case .additional:
                return SBLocalization.localized(key: CartText.Cart.titleAdditional)
            case let .promocode(promocode):
                return SBLocalization.localized(key: CartText.Cart.titlePromocode, arguments: promocode)
            }
        }
    }

    struct Output {
        let fontSize: BehaviorRelay<CGFloat>
        let title: BehaviorRelay<String>
    }
}
