//
//  LottieAnimationModel.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/13/21.
//

import Lottie

enum LottieAnimationModel: String, CaseIterable {
    case orderHistory
    case emptyBasket
    case noInternet
    case upgrade
    case overload
    case payment
    case profile

    var infoText: String {
        switch self {
        case .orderHistory:
            return SBLocalization.localized(key: AnimationsText.InfoText.orderHistory)
        case .emptyBasket:
            return SBLocalization.localized(key: AnimationsText.InfoText.emptyBasket)
        case .noInternet:
            return SBLocalization.localized(key: AnimationsText.InfoText.noInternet)
        case .upgrade:
            return SBLocalization.localized(key: AnimationsText.InfoText.upgrade)
        case .overload:
            return SBLocalization.localized(key: AnimationsText.InfoText.overload)
        case .payment:
            return SBLocalization.localized(key: AnimationsText.InfoText.payment)
        case .profile:
            return SBLocalization.localized(key: AnimationsText.InfoText.profile)
        }
    }

    func getButtonTitle() -> String {
        switch self {
        case .orderHistory, .emptyBasket:
            return SBLocalization.localized(key: AnimationsText.ButtonTitle.orderHistoryEmptyBasket)
        case .noInternet, .overload:
            return SBLocalization.localized(key: AnimationsText.ButtonTitle.noInternetOverload)
        case .upgrade:
            return SBLocalization.localized(key: AnimationsText.ButtonTitle.upgrade)
        case .payment:
            return SBLocalization.localized(key: AnimationsText.ButtonTitle.payment)
        case .profile:
            return SBLocalization.localized(key: AnimationsText.ButtonTitle.profile)
        }
    }

    func getAnimation() -> Animation? {
        return Animation.named(rawValue)
    }

    // MARK: Change when actions are implemented, should send action types

    var isActive: Bool {
        switch self {
        case .payment:
            return false
        case .orderHistory, .emptyBasket, .noInternet, .overload, .upgrade, .profile:
            return true
        }
    }
}
