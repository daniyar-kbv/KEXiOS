//
//  LottieAnimationModel.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/13/21.
//

import Lottie
import UIKit

enum LottieAnimationModel: CaseIterable {
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
            return "Тут будут Ваши заказы, чтобы сделать заказ перейдите в меню"
        case .emptyBasket:
            return "Вы еще ничего не выбрали. Минимальная сумма заказа 1000₸"
        case .noInternet:
            return "Нет связи. Проверьте интернет соединение"
        case .upgrade:
            return "Мы добавили много новых функций и исправили некоторые баги, чтобы вам было удобнее пользоваться приложением"
        case .overload:
            return "В данный момент мы принимаем очень много заказов, пожалуйста попробуйте немного позднее"
        case .payment:
            return "Проводим оплату"
        case .profile:
            return "Вам необходимо авторизоваться, чтобы сделать заказ"
        }
    }

    func getButtonTitle() -> String {
        var title = ""
        switch self {
        case .orderHistory, .emptyBasket:
            title = "Перейти в меню"
        case .noInternet, .overload:
            title = "Попробовать еще раз"
        case .upgrade:
            title = "Обновить приложение"
        case .payment:
            title = "Отменить заказ"
        case .profile:
            title = "Войти"
        }
        return title
    }

    func getAnimation() -> Animation {
        var animation: Animation?

        switch self {
        case .orderHistory:
            animation = Animation.named("\(LottieAnimationModel.orderHistory)")
        case .emptyBasket:
            animation = Animation.named("\(LottieAnimationModel.emptyBasket)")
        case .noInternet:
            animation = Animation.named("\(LottieAnimationModel.noInternet)")
        case .upgrade:
            animation = Animation.named("\(LottieAnimationModel.upgrade)")
        case .overload:
            animation = Animation.named("\(LottieAnimationModel.overload)")
        case .payment:
            animation = Animation.named("\(LottieAnimationModel.payment)")
        case .profile:
            animation = Animation.named("\(LottieAnimationModel.profile)")
        }

        if let selectedAnimation = animation {
            return selectedAnimation
        } else {
            return Animation.named("")!
        }
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
