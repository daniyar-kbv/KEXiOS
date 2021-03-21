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
