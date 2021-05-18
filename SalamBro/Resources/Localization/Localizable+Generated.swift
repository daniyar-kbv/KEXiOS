// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Address {
    internal enum Button {
      /// Save address
      internal static let title = L10n.tr("Localizable", "Address.button.title")
    }
    internal enum Form {
      internal enum Apartment {
        /// Apartment
        internal static let title = L10n.tr("Localizable", "Address.form.apartment.title")
      }
      internal enum Building {
        /// Building*
        internal static let title = L10n.tr("Localizable", "Address.form.building.title")
      }
      internal enum City {
        /// City*
        internal static let title = L10n.tr("Localizable", "Address.form.city.title")
      }
      internal enum Commentary {
        /// Commentary for address
        internal static let title = L10n.tr("Localizable", "Address.form.commentary.title")
      }
      internal enum Country {
        /// Country*
        internal static let title = L10n.tr("Localizable", "Address.form.country.title")
      }
      internal enum Entrance {
        /// Entrance
        internal static let title = L10n.tr("Localizable", "Address.form.entrance.title")
      }
      internal enum Floor {
        /// Floor
        internal static let title = L10n.tr("Localizable", "Address.form.floor.title")
      }
      internal enum Street {
        /// Street*
        internal static let title = L10n.tr("Localizable", "Address.form.street.title")
      }
    }
    internal enum Navigation {
      /// Set delivery address
      internal static let title = L10n.tr("Localizable", "Address.navigation.title")
    }
  }

  internal enum AddressPickCell {
    /// Change
    internal static let changeButton = L10n.tr("Localizable", "AddressPickCell.changeButton")
    /// Deliver to:
    internal static let deliverLabel = L10n.tr("Localizable", "AddressPickCell.deliverLabel")
  }

  internal enum Agreement {
    internal enum Navigation {
      /// Legal documents
      internal static let title = L10n.tr("Localizable", "Agreement.navigation.title")
    }
  }

  internal enum Authorization {
    /// A confirmation SMS code will be sent to this number
    internal static let subtitle = L10n.tr("Localizable", "Authorization.subtitle")
    /// Enter your phone number
    internal static let title = L10n.tr("Localizable", "Authorization.title")
    internal enum Agreement {
      internal enum Active {
        /// User agreement
        internal static let title = L10n.tr("Localizable", "Authorization.agreement.active.title")
      }
      internal enum Inactive {
        /// By continuing, you agree to the collection, processing of personal data and 
        internal static let title = L10n.tr("Localizable", "Authorization.agreement.inactive.title")
      }
    }
    internal enum Button {
      /// Get code
      internal static let title = L10n.tr("Localizable", "Authorization.button.title")
    }
    internal enum NumberField {
      internal enum Placeholder {
        /// Phone number
        internal static let title = L10n.tr("Localizable", "Authorization.numberField.placeholder.title")
      }
    }
  }

  internal enum Brands {
    internal enum Navigation {
      /// Select brand
      internal static let title = L10n.tr("Localizable", "Brands.navigation.title")
    }
  }

  internal enum Cart {
    /// Cart
    internal static let title = L10n.tr("Localizable", "Cart.title")
    internal enum EmptyCart {
      /// You have no items in cart
      internal static let description = L10n.tr("Localizable", "Cart.emptyCart.description")
      internal enum Button {
        /// Go to menu
        internal static let title = L10n.tr("Localizable", "Cart.emptyCart.button.title")
      }
    }
    internal enum OrderButton {
      /// Place an order for %@ ₸
      internal static func title(_ p1: Any) -> String {
        return L10n.tr("Localizable", "Cart.orderButton.title", String(describing: p1))
      }
    }
    internal enum Section0 {
      /// %@ items for %@ ₸
      internal static func title(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "Cart.section0.title", String(describing: p1), String(describing: p2))
      }
    }
    internal enum Section1 {
      /// Additional products
      internal static let title = L10n.tr("Localizable", "Cart.section1.title")
    }
  }

  internal enum CartAdditionalProductCell {
    internal enum Availability {
      /// Product unavailable
      internal static let title = L10n.tr("Localizable", "CartAdditionalProductCell.availability.title")
    }
    internal enum DeleteButton {
      /// Delete
      internal static let title = L10n.tr("Localizable", "CartAdditionalProductCell.deleteButton.title")
    }
  }

  internal enum CartFooter {
    /// Delivery
    internal static let deliveryLabel = L10n.tr("Localizable", "CartFooter.deliveryLabel")
    /// %@ ₸
    internal static func deliveryPrice(_ p1: Any) -> String {
      return L10n.tr("Localizable", "CartFooter.deliveryPrice", String(describing: p1))
    }
    /// %@ items
    internal static func productsCount(_ p1: Any) -> String {
      return L10n.tr("Localizable", "CartFooter.productsCount", String(describing: p1))
    }
    /// %@ ₸
    internal static func productsPrice(_ p1: Any) -> String {
      return L10n.tr("Localizable", "CartFooter.productsPrice", String(describing: p1))
    }
    internal enum PromocodeButton {
      /// Enter promocode
      internal static let title = L10n.tr("Localizable", "CartFooter.promocodeButton.title")
    }
  }

  internal enum CartProductCell {
    internal enum Availability {
      /// Product unavailable
      internal static let title = L10n.tr("Localizable", "CartProductCell.availability.title")
    }
    internal enum DeleteButton {
      /// Delete
      internal static let title = L10n.tr("Localizable", "CartProductCell.deleteButton.title")
    }
  }

  internal enum ChangeLanguage {
    /// English
    internal static let english = L10n.tr("Localizable", "ChangeLanguage.english")
    /// Kazakh
    internal static let kazakh = L10n.tr("Localizable", "ChangeLanguage.kazakh")
    /// Russian
    internal static let russian = L10n.tr("Localizable", "ChangeLanguage.russian")
    /// Application Language
    internal static let title = L10n.tr("Localizable", "ChangeLanguage.title")
    internal enum NavigationBar {
      /// Select language
      internal static let title = L10n.tr("Localizable", "ChangeLanguage.navigationBar.title")
    }
  }

  internal enum ChangeName {
    /// E-mail
    internal static let emailLabel = L10n.tr("Localizable", "ChangeName.emailLabel")
    /// Name
    internal static let nameLabel = L10n.tr("Localizable", "ChangeName.nameLabel")
    internal enum NameField {
      /// insert name
      internal static let placeholder = L10n.tr("Localizable", "ChangeName.nameField.placeholder")
    }
    internal enum NavigationBar {
      /// Change
      internal static let title = L10n.tr("Localizable", "ChangeName.navigationBar.title")
    }
    internal enum SaveButton {
      /// Save
      internal static let title = L10n.tr("Localizable", "ChangeName.saveButton.title")
    }
  }

  internal enum Cities {
    /// Aktau
    internal static let aktau = L10n.tr("Localizable", "Cities.aktau")
    /// Aktobe
    internal static let aktobe = L10n.tr("Localizable", "Cities.aktobe")
    /// Almaty
    internal static let almaty = L10n.tr("Localizable", "Cities.almaty")
    /// Nur-Sultan
    internal static let nursultan = L10n.tr("Localizable", "Cities.nursultan")
    /// Shymkent
    internal static let shymkent = L10n.tr("Localizable", "Cities.shymkent")
    /// Taldykorgan
    internal static let taldykorgan = L10n.tr("Localizable", "Cities.taldykorgan")
    /// Taraz
    internal static let taraz = L10n.tr("Localizable", "Cities.taraz")
    /// Uralsk
    internal static let uralsk = L10n.tr("Localizable", "Cities.uralsk")
  }

  internal enum CitiesList {
    internal enum Navigation {
      /// Select city
      internal static let title = L10n.tr("Localizable", "CitiesList.navigation.title")
    }
  }

  internal enum Commentary {
    internal enum AddressField {
      /// Commentary(apartment N, entrance, ...)
      internal static let title = L10n.tr("Localizable", "Commentary.addressField.title")
    }
    internal enum Button {
      /// Done
      internal static let title = L10n.tr("Localizable", "Commentary.button.title")
    }
  }

  internal enum Common {
    /// Close
    internal static let close = L10n.tr("Localizable", "Common.close")
    /// Error
    internal static let error = L10n.tr("Localizable", "Common.error")
  }

  internal enum CountriesList {
    internal enum Navigation {
      /// Select country
      internal static let title = L10n.tr("Localizable", "CountriesList.navigation.title")
    }
  }

  internal enum Country {
    /// Kazakhstan
    internal static let kazakhstan = L10n.tr("Localizable", "Country.Kazakhstan")
    /// Russian Federation
    internal static let russia = L10n.tr("Localizable", "Country.Russia")
    /// USA
    internal static let usa = L10n.tr("Localizable", "Country.USA")
  }

  internal enum CountryCodePicker {
    internal enum Navigation {
      /// Select country code
      internal static let title = L10n.tr("Localizable", "CountryCodePicker.navigation.title")
    }
  }

  internal enum GetName {
    /// What is your name?
    internal static let title = L10n.tr("Localizable", "GetName.title")
    internal enum Button {
      /// Next
      internal static let title = L10n.tr("Localizable", "GetName.button.title")
    }
    internal enum Field {
      /// Enter your name
      internal static let title = L10n.tr("Localizable", "GetName.field.title")
    }
  }

  internal enum MainTab {
    internal enum Cart {
      /// Cart
      internal static let title = L10n.tr("Localizable", "MainTab.Cart.Title")
    }
    internal enum Menu {
      /// Menu
      internal static let title = L10n.tr("Localizable", "MainTab.Menu.Title")
    }
    internal enum Profile {
      /// Profile
      internal static let title = L10n.tr("Localizable", "MainTab.Profile.Title")
    }
    internal enum Support {
      /// Help
      internal static let title = L10n.tr("Localizable", "MainTab.Support.Title")
    }
  }

  internal enum MapView {
    internal enum AddressField {
      /// Delivery address
      internal static let title = L10n.tr("Localizable", "MapView.addressField.title")
    }
    internal enum CommentaryLabel {
      /// Commentary(apartment N, entrance, ...)
      internal static let title = L10n.tr("Localizable", "MapView.commentaryLabel.title")
    }
    internal enum ProceedButton {
      /// Proceed to order
      internal static let title = L10n.tr("Localizable", "MapView.proceedButton.title")
    }
  }

  internal enum Menu {
    internal enum Categories {
      /// Burgers
      internal static let burgers = L10n.tr("Localizable", "Menu.categories.burgers")
      /// Combo
      internal static let combo = L10n.tr("Localizable", "Menu.categories.combo")
      /// Drinks
      internal static let drinks = L10n.tr("Localizable", "Menu.categories.drinks")
      /// Hot-dogs
      internal static let hotdogs = L10n.tr("Localizable", "Menu.categories.hotdogs")
      /// Other
      internal static let other = L10n.tr("Localizable", "Menu.categories.other")
      /// Sauces
      internal static let sauces = L10n.tr("Localizable", "Menu.categories.sauces")
    }
  }

  internal enum MenuDetail {
    /// Choose drink
    internal static let additionalItemLabel = L10n.tr("Localizable", "MenuDetail.additionalItemLabel")
    /// Change
    internal static let chooseAdditionalItemButton = L10n.tr("Localizable", "MenuDetail.chooseAdditionalItemButton")
    /// Commentary to dish
    internal static let commentaryField = L10n.tr("Localizable", "MenuDetail.commentaryField")
    /// Add to cart for
    internal static let proceedButton = L10n.tr("Localizable", "MenuDetail.proceedButton")
  }

  internal enum OrderHistory {
    /// Order history
    internal static let title = L10n.tr("Localizable", "OrderHistory.title")
  }

  internal enum Profile {
    /// Change application language
    internal static let changeLanguage = L10n.tr("Localizable", "Profile.changeLanguage")
    /// Delivery addresses
    internal static let deliveryAddress = L10n.tr("Localizable", "Profile.deliveryAddress")
    /// Order history
    internal static let orderHistory = L10n.tr("Localizable", "Profile.orderHistory")
    internal enum EditButton {
      /// Edit
      internal static let title = L10n.tr("Localizable", "Profile.editButton.title")
    }
    internal enum LogoutButton {
      /// Logout
      internal static let title = L10n.tr("Localizable", "Profile.logoutButton.title")
    }
    internal enum NavigationBar {
      /// Profile
      internal static let title = L10n.tr("Localizable", "Profile.navigationBar.title")
    }
  }

  internal enum Promocode {
    /// Use
    internal static let button = L10n.tr("Localizable", "Promocode.button")
    /// Enter promocode
    internal static let field = L10n.tr("Localizable", "Promocode.field")
  }

  internal enum RateOrder {
    /// Your rate will help us to increase quality of delivery
    internal static let description = L10n.tr("Localizable", "RateOrder.description")
    /// Rate order
    internal static let title = L10n.tr("Localizable", "RateOrder.title")
    internal enum AverageRate {
      /// Average is not cool. What should we\nfix next time?
      internal static let subtitle = L10n.tr("Localizable", "RateOrder.averageRate.subtitle")
      /// Clear! What should we improve?
      internal static let title = L10n.tr("Localizable", "RateOrder.averageRate.title")
    }
    internal enum BadRate {
      /// We want to fix this! Something went wrong,\nhow do you need it? Your comments will help us much!
      internal static let subtitle = L10n.tr("Localizable", "RateOrder.badRate.subtitle")
      /// We apologise! Something went wrong?
      internal static let title = L10n.tr("Localizable", "RateOrder.badRate.title")
    }
    internal enum Cell {
      internal enum CourierNotFoundClient {
        /// The courier did not find me
        internal static let text = L10n.tr("Localizable", "RateOrder.cell.courierNotFoundClient.text")
      }
      internal enum CourierWork {
        /// Courier work
        internal static let text = L10n.tr("Localizable", "RateOrder.cell.courierWork.text")
      }
      internal enum DeliveryTime {
        /// Delivery time
        internal static let text = L10n.tr("Localizable", "RateOrder.cell.deliveryTime.text")
      }
      internal enum FoodIsCold {
        /// The food was cold
        internal static let text = L10n.tr("Localizable", "RateOrder.cell.foodIsCold.text")
      }
      internal enum FoodIsMissing {
        /// Missing dish
        internal static let text = L10n.tr("Localizable", "RateOrder.cell.foodIsMissing.text")
      }
      internal enum GivenTime {
        /// Suggested time
        internal static let text = L10n.tr("Localizable", "RateOrder.cell.givenTime.text")
      }
    }
    internal enum CommentaryField {
      /// Add commentary
      internal static let placeholder = L10n.tr("Localizable", "RateOrder.commentaryField.placeholder")
    }
    internal enum ExcellentRate {
      /// What did you like the most?
      internal static let subtitle = L10n.tr("Localizable", "RateOrder.excellentRate.subtitle")
      /// It's good that everything went well!
      internal static let title = L10n.tr("Localizable", "RateOrder.excellentRate.title")
    }
    internal enum GoodRate {
      /// 4/5 is good - but not perfect.\nWhat should we improve next time?
      internal static let subtitle = L10n.tr("Localizable", "RateOrder.goodRate.subtitle")
      /// Thank you! What could we\nimprove?
      internal static let title = L10n.tr("Localizable", "RateOrder.goodRate.title")
    }
    internal enum SubmitButton {
      /// Send
      internal static let title = L10n.tr("Localizable", "RateOrder.submitButton.title")
    }
  }

  internal enum Rating {
    /// Information
    internal static let information = L10n.tr("Localizable", "Rating.information")
    /// General
    internal static let overall = L10n.tr("Localizable", "Rating.overall")
    /// Participate
    internal static let participate = L10n.tr("Localizable", "Rating.participate")
    /// PLACE
    internal static let place = L10n.tr("Localizable", "Rating.place")
    /// SUM
    internal static let sum = L10n.tr("Localizable", "Rating.sum")
    /// Ratings
    internal static let title = L10n.tr("Localizable", "Rating.title")
    /// USER
    internal static let user = L10n.tr("Localizable", "Rating.user")
    /// Weekly
    internal static let weekly = L10n.tr("Localizable", "Rating.weekly")
  }

  internal enum ShareOrder {
    /// Share
    internal static let submitButton = L10n.tr("Localizable", "ShareOrder.submitButton")
  }

  internal enum Suggest {
    internal enum AddressField {
      /// Enter address
      internal static let title = L10n.tr("Localizable", "Suggest.addressField.title")
    }
    internal enum Button {
      /// Cancel
      internal static let title = L10n.tr("Localizable", "Suggest.button.title")
    }
  }

  internal enum Support {
    /// Сall the call-center
    internal static let callcenter = L10n.tr("Localizable", "Support.callcenter")
    /// Legal documents
    internal static let documents = L10n.tr("Localizable", "Support.documents")
    /// Support
    internal static let title = L10n.tr("Localizable", "Support.title")
  }

  internal enum Update {
    internal enum Button {
      /// Update app
      internal static let title = L10n.tr("Localizable", "Update.button.title")
    }
    internal enum Title {
      /// We added a lot of new features and fixed several bugs for your convenient use
      internal static let description = L10n.tr("Localizable", "Update.title.description")
    }
  }

  internal enum Verification {
    /// We sent it to number %@
    internal static func subtitle(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Verification.subtitle", String(describing: p1))
    }
    /// Enter the code from the message
    internal static let title = L10n.tr("Localizable", "Verification.title")
    internal enum Button {
      /// Resend code again
      internal static let timeout = L10n.tr("Localizable", "Verification.button.timeout")
      /// Resend again in: %@
      internal static func title(_ p1: Any) -> String {
        return L10n.tr("Localizable", "Verification.button.title", String(describing: p1))
      }
    }
  }

  internal enum AddressPicker {
    /// Add a new delivery address
    internal static let add = L10n.tr("Localizable", "address_picker.add")
    /// Delivery addresses
    internal static let titleMany = L10n.tr("Localizable", "address_picker.titleMany")
    /// Delivery address
    internal static let titleOne = L10n.tr("Localizable", "address_picker.titleOne")
  }

  internal enum SelectMainInfo {
    /// Address
    internal static let address = L10n.tr("Localizable", "select_main_info.address")
    /// Brand
    internal static let brand = L10n.tr("Localizable", "select_main_info.brand")
    /// City
    internal static let city = L10n.tr("Localizable", "select_main_info.city")
    /// Country
    internal static let country = L10n.tr("Localizable", "select_main_info.country")
    /// The presence or absence of a particular brand depends on your\ndelivery addresses
    internal static let description = L10n.tr("Localizable", "select_main_info.description")
    /// Save
    internal static let save = L10n.tr("Localizable", "select_main_info.save")
    /// Delivery address
    internal static let title = L10n.tr("Localizable", "select_main_info.title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
