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
    case closed

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
        case .closed:
            return SBLocalization.localized(key: AnimationsText.InfoText.closed)
        }
    }

    var isActive: Bool {
        switch self {
        case .payment, .closed:
            return false
        case .orderHistory, .emptyBasket, .noInternet, .overload, .upgrade, .profile:
            return true
        }
    }

    var animationLoopMode: LottieLoopMode {
        switch self {
        case .orderHistory, .emptyBasket, .noInternet, .upgrade, .overload, .payment:
            return .loop
        case .profile, .closed:
            return .playOnce
        }
    }

    var animationSize: CGSize {
        switch self {
        case .orderHistory, .emptyBasket, .noInternet, .upgrade, .overload, .payment, .closed:
            return CGSize(width: 272, height: 200)
        case .profile:
            return CGSize(width: 736, height: 200)
        }
    }

    var withButton: Bool {
        switch self {
        case .orderHistory, .emptyBasket, .noInternet, .upgrade, .overload, .payment, .profile:
            return true
        case .closed:
            return false
        }
    }

    var buttonStyle: SBSubmitButton.Style {
        switch self {
        case .orderHistory, .emptyBasket, .noInternet, .overload, .upgrade, .profile:
            return .emptyRed
        case .payment:
            return .emptyGray
        case .closed:
            return .emptyRed
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
        default:
            return ""
        }
    }

    func getAnimation() -> Animation? {
        return Animation.named(rawValue)
    }
}
