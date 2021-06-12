//
//  LottieAnimationModel.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/13/21.
//

import Foundation

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

    var buttonTitle: String {
        switch self {
        case .orderHistory, .emptyBasket:
            return "Перейти в меню"
        case .noInternet, .overload:
            return "Попробовать еще раз"
        case .upgrade:
            return "Обновить приложение"
        case .payment:
            return "Отменить заказ"
        case .profile:
            return "Войти"
        }
    }

    var isActive: Bool {
        switch self {
        case .payment:
            return false
        case .orderHistory, .emptyBasket, .noInternet, .overload, .upgrade, .profile:
            return true
        }
    }
}
