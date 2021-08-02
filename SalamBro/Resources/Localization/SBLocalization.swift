//
//  SBLocalization.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 01.07.2021.
//

import Foundation

protocol UILocalizable {
    var localized: String { get }
}

enum TabBarText: String, UILocalizable {
    case profileTitle = "MainTab.Profile.Title"
    case menuTitle = "MainTab.Menu.Title"
    case supportTitle = "MainTab.Support.Title"
    case cartTitle = "MainTab.Cart.Title"

    var localized: String { rawValue }
}

enum CommentaryText: String, UILocalizable {
    case buttonTitle = "Commentary.button.title"

    var localized: String { rawValue }
}

enum ErrorText: UILocalizable {
    enum Alert: String, UILocalizable {
        case title = "Common.error"
        case action = "Common.close"

        var localized: String { rawValue }
    }

    enum Network: String, UILocalizable {
        case mappingError = "Error.mappingError"
        case noData = "Error.noData"

        var localized: String { rawValue }
    }

    var localized: String { "" }
}

enum AlertText: String, UILocalizable {
    case ok = "Alert.ok"
    case errorTitle = "Alert.Error.title"

    var localized: String { rawValue }
}

enum AnimationsText: UILocalizable {
    enum InfoText: String, UILocalizable {
        case orderHistory = "Animation.InfoText.orderHistory"
        case emptyBasket = "Animation.InfoText.emptyBasket"
        case noInternet = "Animation.InfoText.noInternet"
        case upgrade = "Animation.InfoText.upgrade"
        case overload = "Animation.InfoText.overload"
        case payment = "Animation.InfoText.payment"
        case profile = "Animation.InfoText.profile"

        var localized: String { rawValue }
    }

    enum ButtonTitle: String, UILocalizable {
        case orderHistoryEmptyBasket = "Animation.ButtonTitle.orderHistory.emptyBasket"
        case noInternetOverload = "Animation.ButtonTitle.noInternet.overload"
        case upgrade = "Animation.ButtonTitle.upgrade"
        case payment = "Animation.ButtonTitle.payment"
        case profile = "Animation.ButtonTitleprofile"

        var localized: String { rawValue }
    }

    var localized: String { "" }
}

enum AddressText: UILocalizable {
    enum Countries: String, UILocalizable {
        case title = "CountriesList.navigation.title"

        var localized: String { rawValue }
    }

    enum Cities: String, UILocalizable {
        case title = "CitiesList.navigation.title"

        var localized: String { rawValue }
    }

    enum Map: String, UILocalizable {
        case addressField = "MapView.addressField.title"
        case commentaryField = "MapView.commentaryLabel.title"
        case proceedButton = "MapView.proceedButton.title"

        var localized: String { rawValue }

        enum Commentary: String, UILocalizable {
            case placeholder = "Commentary.addressField.title"

            var localized: String { rawValue }
        }

        enum LocationAlert: String, UILocalizable {
            case title = "MapView.LocationAlert.title"
            case message = "MapView.LocationAlert.message"

            var localized: String { rawValue }
        }
    }

    enum Suggest: String, UILocalizable {
        case fieldTitle = "Suggest.addressField.title"
        case buttonTitle = "Suggest.button.title"

        var localized: String { rawValue }
    }

    enum Brands: String, UILocalizable {
        case title = "Brands.navigation.title"

        var localized: String { rawValue }
    }

    enum AddressPick: String, UILocalizable {
        case add = "address_picker.add"

        var localized: String { rawValue }
    }

    enum SelectMainInfo: String, UILocalizable {
        case countryTitle = "select_main_info.country"
        case countryPlaceholder = "select_main_info.country.placeholder"
        case cityTitle = "select_main_info.city"
        case cityPlaceholder = "select_main_info.city.placeholder"
        case addressTitle = "select_main_info.address"
        case addressPlaceholder = "select_main_info.address.placeholder"
        case brandTitle = "select_main_info.brand"
        case brandPlaceholder = "select_main_info.brand.placeholder"
        case title = "select_main_info.title"
        case description = "select_main_info.description"
        case save = "select_main_info.save"
        case alertTitle = "select_main_info.alert.title"
        case alertBody = "select_main_info.alert.body.address"
        case alertBodyBrand = "select_main_info.alert.body.brand"
        case alertActionYes = "select_main_info.alert.action.yes"
        case alertActionNo = "select_main_info.alert.action.no"

        var localized: String { rawValue }

        enum Alert: String, UILocalizable {
            case title = "select_main_info.alert.title"
            case bodyAddress = "select_main_info.alert.body.address"
            case bodyBrand = "select_main_info.alert.body.brand"
            case actionYes = "select_main_info.alert.action.yes"
            case actionNo = "select_main_info.alert.action.no"

            var localized: String { rawValue }
        }
    }

    var localized: String { "" }
}

enum AuthorizationText: UILocalizable {
    enum Auth: String, UILocalizable {
        case title = "Authorization.title"
        case subtitle = "Authorization.subtitle"
        case numberPlaceholder = "Authorization.numberField.placeholder.title"
        case buttonTitle = "Authorization.button.title"

        var localized: String { rawValue }

        enum Agreement: String, UILocalizable {
            case inactive = "Authorization.agreement.inactive.title"
            case active = "Authorization.agreement.active.title"

            var localized: String { rawValue }
        }
    }

    enum Verification: String, UILocalizable {
        case title = "Verification.title"
        case subtitle = "Verification.subtitle"

        var localized: String { rawValue }

        enum Button: String, UILocalizable {
            case title = "Verification.button.title"
            case timeout = "Verification.button.timeout"

            var localized: String { rawValue }
        }
    }

    enum CountryCode: String, UILocalizable {
        case title = "CountryCodePicker.navigation.title"

        var localized: String { rawValue }
    }

    var localized: String { "" }

    enum GetName: String, UILocalizable {
        case title = "GetName.title"
        case fieldTitle = "GetName.field.title"
        case buttonTitle = "GetName.button.title"

        var localized: String { rawValue }
    }
}

enum MenuText: UILocalizable {
    enum Menu: UILocalizable {
        enum Address: String, UILocalizable {
            case changeButton = "AddressPickCell.changeButton"
            case addressTitle = "AddressPickCell.deliverLabel"

            var localized: String { rawValue }
        }

        var localized: String { "" }
    }

    enum MenuDetail: String, UILocalizable {
        case proceedButton = "MenuDetail.proceedButton"
        case commentPlaceholder = "MenuDetail.commentaryField"
        case changeButton = "MenuDetail.chooseAdditionalItemButton"
        case required = "MenuDetail.required"
        case choose = "MenuDetail.choose"
        case position = "MenuDetail.position"
        case positionLessOrEqualFour = "MenuDetail.positionLessOrEqualFour"
        case positionGreaterThanFour = "MenuDetail.positionGreaterThanFour"
        case additional = "MenuDetail.additional"
        case max = "MenuDetail.max"
        case chooseAdditional = "MenuDetail.chooseAdditional"
        case added = "MenuDetail.added"

        var localized: String { rawValue }
    }

    var localized: String { "" }
}

enum ProfileText: UILocalizable {
    enum Profile: String, UILocalizable {
        case title = "Profile.navigationBar.title"
        case editButton = "Profile.editButton.title"
        case orderHistory = "Profile.orderHistory"
        case changeLanguage = "Profile.changeLanguage"
        case deliveryAddress = "Profile.deliveryAddress"
        case logoutButton = "Profile.logoutButton.title"

        var localized: String { rawValue }

        enum Alert: String, UILocalizable {
            case title = "Profile.Alert.title"
            case message = "Profile.Alert.message"

            var localized: String { rawValue }

            enum Action: String, UILocalizable {
                case yes = "Profile.Alert.Action.yes"
                case no = "Profile.Alert.Action.no"

                var localized: String { rawValue }
            }
        }
    }

    enum ChangeName: String, UILocalizable {
        case title = "ChangeName.navigationBar.title"
        case placeholder = "ChangeName.nameField.placeholder"
        case saveButton = "ChangeName.saveButton.title"
        case name = "ChangeName.nameLabel"
        case edit = "ChangeName.emailLabel"

        var localized: String { rawValue }
    }

    enum ChangeLanguage: String, UILocalizable {
        case title = "ChangeLanguage.title"
        case english = "ChangeLanguage.english"
        case russian = "ChangeLanguage.russian"
        case kazakh = "ChangeLanguage.kazakh"

        var localized: String { rawValue }
    }

    enum AddressList: String, UILocalizable {
        case title = "address_picker.titleMany"

        var localized: String { rawValue }
    }

    enum AddressDetail: String, UILocalizable {
        case title = "address_picker.titleOne"
        case commentaryTitle = "AddressDetail.commentaryTitleLabel"

        var localized: String { rawValue }

        enum Alert: String, UILocalizable {
            case title = "AddressDetail.Alert.title"
            case message = "AddressDetail.Alert.message"

            var localized: String { rawValue }

            enum Action: String, UILocalizable {
                case yes = "AddressDetail.Alert.Action.yes"
                case no = "AddressDetail.Alert.Action.no"

                var localized: String { rawValue }
            }
        }
    }

    enum OrderHistory: String, UILocalizable {
        case title = "OrderHistory.title"
        case shipping = "OrderHistory.shipping"
        case sum = "OrderHistory.sum"
        case deliveryAddress = "OrderHistory.deliveryAddress"
        case paymentDetails = "OrderHistory.paymentDetails"
        case orderStatus = "OrderHistory.orderStatus"
        case sendBill = "OrderHistory.sendBill"
        case rateOrder = "OrderHistory.rateOrder"
        case repeatOrder = "OrderHistory.repeatOrder"

        var localized: String { rawValue }
    }

    enum ShareOrder: String, UILocalizable {
        case submitButton = "ShareOrder.submitButton"

        var localized: String { rawValue }
    }

    enum RateOrder: String, UILocalizable {
        case title = "RateOrder.title"
        case submitButton = "RateOrder.submitButton.title"
        case commentaryPlaceholder = "RateOrder.commentaryField.placeholder"

        var localized: String { rawValue }

        enum Description: String, UILocalizable {
            case defaultTitle = "RateOrder.description"

            var localized: String { rawValue }
        }
    }

    var localized: String { "" }
}

enum SupportText: UILocalizable {
    enum Support: String, UILocalizable {
        case title = "Support.title"
        case callCenter = "Support.callcenter"

        var localized: String { rawValue }
    }

    var localized: String { "" }
}

enum CartText: UILocalizable {
    enum Cart: String, UILocalizable {
        case navigationTitle = "Cart.title"
        case titleFirst = "Cart.section0.title"
        case titleSecond = "Cart.section1.title"
        case buttonTitle = "Cart.orderButton.title"

        var localized: String { rawValue }

        enum Footer: String, UILocalizable {
            case promocodeButton = "CartFooter.promocodeButton.title"
            case productsPrice = "CartFooter.productsPrice"
            case productsCount = "CartFooter.productsCount"
            case deliveryTitle = "CartFooter.deliveryLabel"
            case deliveryPrice = "CartFooter.deliveryPrice"

            var localized: String { rawValue }
        }

        enum ProductCell: String, UILocalizable {
            case deleteButton = "CartProductCell.deleteButton.title"
            case availability = "CartProductCell.availability.title"

            var localized: String { rawValue }
        }

        enum AdditionalCell: String, UILocalizable {
            case deleteButton = "CartAdditionalProductCell.deleteButton.title"
            case availability = "CartAdditionalProductCell.availability.title"

            var localized: String { rawValue }
        }

        enum Promocode: String, UILocalizable {
            case button = "Promocode.button"
            case placeholder = "Promocode.field"

            var localized: String { rawValue }
        }
    }

    var localized: String { "" }
}

enum PaymentText: UILocalizable {
    enum PaymentSelection: String, UILocalizable {
        case title = "Payment.Selection.title"
        case paymentMethod = "Payment.Selection.paymentMethod"
        case choosePaymentMethod = "Payment.Selection.choosePaymentMethod"
        case change = "Payment.Selection.change"
        case bill = "Payment.Selection.bill"
        case orderPayment = "Payment.Selection.orderPayment"

        var localized: String { rawValue }
    }

    enum PaymentMethod: String, UILocalizable {
        case title = "Payment.Method.PaymentMethod.title"
        case errorDescription = "Payment.Method.PaymentMethodError.description"

        var localized: String { rawValue }

        enum MethodTitle: String, UILocalizable {
            case savedCard = "Payment.Method.PaymentMethod.Title.savedCard"
            case card = "Payment.Method.PaymentMethod.Title.card"
            case cash = "Payment.Method.PaymentMethod.Title.cash"

            var localized: String { rawValue }
        }
    }

    enum PaymentCard: String, UILocalizable {
        case title = "Payment.Card.title"
        case saveCard = "Payment.Card.saveCard"
        case cardNumber = "Payment.Card.cardNumber"
        case expiryDate = "Payment.Card.expiryDate"
        case cardholderName = "Payment.Card.cardholderName"
        case saveButton = "Payment.Card.saveButton"

        var localized: String { rawValue }

        enum Error: String, UILocalizable {
            case invalidCard = "Payment.Card.Error.invalidCard"
            case invalidExpiryDate = "Payment.Card.Error.invalidExpiryDate"

            var localized: String { rawValue }
        }
    }

    enum PaymentCash: String, UILocalizable {
        case topText = "Payment.Cash.topText"

        var localized: String { rawValue }

        enum Title: String, UILocalizable {
            case base = "Payment.Cash.titleDefault"
            case change = "Payment.Cash.titleChange"

            var localized: String { rawValue }
        }

        enum Field: String, UILocalizable {
            case placeholder = "Payment.Cash.fieldPlaceholder"
            case description = "Payment.Cash.fieldDescription"

            var localized: String { rawValue }
        }

        enum Button: String, UILocalizable {
            case noChange = "Payment.Cash.Button.noChange"
            case submit = "Payment.Cash.Button.submit"

            var localized: String { rawValue }
        }
    }

    var localized: String { "" }
}

enum SBLocalization {
    static func localized(key: UILocalizable) -> String {
        guard let path = Bundle.main.path(forResource: DefaultStorageImpl.sharedStorage.appLocale,
                                          ofType: "lproj"),
            let bundle = Bundle(path: path)
        else {
            return NSLocalizedString(key.localized, tableName: "Localizable", comment: "")
        }

        return NSLocalizedString(key.localized, tableName: "Localizable", bundle: bundle, comment: "")
    }

    static func localized(key: UILocalizable, arguments: String...) -> String {
        let localizedString = localized(key: key)

        return String(format: localizedString, arguments: arguments)
    }
}
