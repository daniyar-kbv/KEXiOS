//
//  Constants.swift
//  SalamBro
//
//  Created by Arystan on 4/12/21.
//

import UIKit

struct Constants {
    let screenSize: CGRect = UIScreen.main.bounds

    static let apiKey = getPlistValue(by: "API_KEY")
    static let cloudpaymentsMerchantId = getPlistValue(by: "CLOUDPAYMENTS_MERCHANT_ID")
    static let applePayMerchantId = getPlistValue(by: "APPLE_PAY_MERCHANT_ID")
    static let yandexApiKey = getPlistValue(by: "Yandex_API_KEY")

    enum URLs {
        static let promotionURL = APIBase.dev.appendingPathComponent("/promotions/%@/")

        enum APIBase {
            static let dev = URL(string: "https://api.kexbrands.kz")!
        }

        static let yandexURL = URL(string: "https://geocode-maps.yandex.ru/")!
    }

    enum Map {
        enum Zoom {
            static let initial: Float = 13.0
            static let move: Float = 17.0
        }

        enum Coordinates {
            static let ALALatitude: Double = 43.241044
            static let ALALongitude: Double = 76.927359
        }
    }

    enum ErrorCode {
        static let orderAlreadyExists = "order_already_exists"
        static let orderAlreadyPaid = "order_already_paid"
        static let notFound = "not_found"
        static let terminalNotFound = "terminal_not_found"
        static let branchIsClosed = "branch_is_closed"
    }

    enum StatusCode {
        static let noContent = 204
        static let unauthorized = 401
    }

    enum InternalNotification {
        case unauthorize
        case userInfo
        case leadUUID
        case updateMenu
        case clearCart
        case cart
        case userAddresses
        case startFirstFlow
        case showPaymentProcess
        case hidePaymentProcess

        var name: Notification.Name {
            switch self {
            case .unauthorize: return .init("Unauthorize")
            case .userInfo: return .init("UserInfo")
            case .leadUUID: return .init("LeadUUID")
            case .updateMenu: return .init("UpdateMenu")
            case .clearCart: return .init("ClearCart")
            case .cart: return .init("Cart")
            case .userAddresses: return .init("UserAddresses")
            case .startFirstFlow: return .init("StartFirstFlow")
            case .showPaymentProcess: return .init("ShowPaymentProcess")
            case .hidePaymentProcess: return .init("HidePaymentProcess")
            }
        }
    }
}

extension Constants {
    private static func getPlistValue(by key: String) -> String {
        guard let filePath = Bundle.main.path(forResource: "SalamBro-Info", ofType: "plist") else {
            fatalError("Couldn't find file 'SalamBro-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: key) as? String else {
            fatalError("Couldn't find key '\(key)' in 'SalamBro-Info.plist'.")
        }
        return value
    }
}
