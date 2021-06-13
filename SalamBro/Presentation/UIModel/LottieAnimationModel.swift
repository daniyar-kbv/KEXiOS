//
//  LottieAnimationModel.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/13/21.
//

import Lottie
import UIKit

enum LottieAnimationModel {
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

    func getAnimationView() -> AnimationView {
        let animationView = AnimationView()
        switch self {
        case .orderHistory:
            animationView.animation = Animation.named("\(LottieAnimationModel.orderHistory)")
        case .emptyBasket:
            animationView.animation = Animation.named("\(LottieAnimationModel.orderHistory)")
        case .noInternet:
            animationView.animation = Animation.named("\(LottieAnimationModel.orderHistory)")
        case .upgrade:
            animationView.animation = Animation.named("\(LottieAnimationModel.orderHistory)")
        case .overload:
            animationView.animation = Animation.named("\(LottieAnimationModel.orderHistory)")
        case .payment:
            animationView.animation = Animation.named("\(LottieAnimationModel.orderHistory)")
        case .profile:
            animationView.animation = Animation.named("\(LottieAnimationModel.orderHistory)")
        }
        return animationView
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
