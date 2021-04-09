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

  internal enum Agreement {
    internal enum Navigation {
      /// User agreement
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
      /// %@ items for %@
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
    internal enum NavigationBar {
      /// Select language
      internal static let title = L10n.tr("Localizable", "ChangeLanguage.navigationBar.title")
    }
  }

  internal enum ChangeName {
    internal enum NameField {
      /// insert name
      internal static let placeholder = L10n.tr("Localizable", "ChangeName.nameField.placeholder")
    }
    internal enum NavigationBar {
      /// Change name
      internal static let title = L10n.tr("Localizable", "ChangeName.navigationBar.title")
    }
    internal enum SaveButton {
      /// Save
      internal static let title = L10n.tr("Localizable", "ChangeName.saveButton.title")
    }
  }

  internal enum CitiesList {
    internal enum Navigation {
      /// Select your city
      internal static let title = L10n.tr("Localizable", "CitiesList.navigation.title")
    }
  }

  internal enum CountriesList {
    internal enum Navigation {
      /// Select your country
      internal static let title = L10n.tr("Localizable", "CountriesList.navigation.title")
    }
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

  internal enum Profile {
    /// Change application language
    internal static let changeLanguage = L10n.tr("Localizable", "Profile.changeLanguage")
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
      /// Resend again in: %@
      internal static func title(_ p1: Any) -> String {
        return L10n.tr("Localizable", "Verification.button.title", String(describing: p1))
      }
    }
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
