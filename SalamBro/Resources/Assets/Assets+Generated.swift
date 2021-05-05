// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
    import AppKit
#elseif os(iOS)
    import UIKit
#elseif os(tvOS) || os(watchOS)
    import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
    internal static let accentColor = ColorAsset(name: "AccentColor")
    internal static let line = ImageAsset(name: "Line")
    internal static let logo1024 = ImageAsset(name: "Logo1024")
    internal static let searchResult = ImageAsset(name: "SearchResult")
    internal static let ad = ImageAsset(name: "ad")
    internal static let back = ImageAsset(name: "back")
    internal enum Brands {
        internal static let chicken1 = ImageAsset(name: "Chicken1")
        internal static let chicken2 = ImageAsset(name: "Chicken2")
        internal static let chicken3 = ImageAsset(name: "Chicken3")
        internal static let chicken4 = ImageAsset(name: "Chicken4")
        internal static let halalBite1 = ImageAsset(name: "HalalBite1")
        internal static let halalBite2 = ImageAsset(name: "HalalBite2")
        internal static let halalBite3 = ImageAsset(name: "HalalBite3")
        internal static let halalBite4 = ImageAsset(name: "HalalBite4")
        internal static let halalSlice1 = ImageAsset(name: "HalalSlice1")
        internal static let halalSlice2 = ImageAsset(name: "HalalSlice2")
        internal static let halalSlice3 = ImageAsset(name: "HalalSlice3")
        internal static let halalSlice4 = ImageAsset(name: "HalalSlice4")
        internal static let marmelad1 = ImageAsset(name: "Marmelad1")
        internal static let marmelad2 = ImageAsset(name: "Marmelad2")
        internal static let marmelad3 = ImageAsset(name: "Marmelad3")
        internal static let marmelad4 = ImageAsset(name: "Marmelad4")
        internal static let qazaqGuys1 = ImageAsset(name: "QazaqGuys1")
        internal static let qazaqGuys2 = ImageAsset(name: "QazaqGuys2")
        internal static let qazaqGuys3 = ImageAsset(name: "QazaqGuys3")
        internal static let qazaqGuys4 = ImageAsset(name: "QazaqGuys4")
        internal static let salamBro1 = ImageAsset(name: "SalamBro1")
        internal static let salamBro2 = ImageAsset(name: "SalamBro2")
        internal static let salamBro3 = ImageAsset(name: "SalamBro3")
        internal static let salamBro4 = ImageAsset(name: "SalamBro4")
        internal static let sushi1 = ImageAsset(name: "Sushi1")
        internal static let sushi2 = ImageAsset(name: "Sushi2")
        internal static let sushi3 = ImageAsset(name: "Sushi3")
        internal static let sushi4 = ImageAsset(name: "Sushi4")
        internal static let zhekas1 = ImageAsset(name: "Zhekas1")
        internal static let zhekas2 = ImageAsset(name: "Zhekas2")
        internal static let zhekas3 = ImageAsset(name: "Zhekas3")
        internal static let zhekas4 = ImageAsset(name: "Zhekas4")
    }

    internal static let cart = ImageAsset(name: "cart")
    internal static let chevronBottom = ImageAsset(name: "chevron.bottom")
    internal static let chevronRight = ImageAsset(name: "chevron.right")
    internal static let cola = ImageAsset(name: "cola")
    internal static let documents = ImageAsset(name: "documents")
    internal static let emptyCart = ImageAsset(name: "emptyCart")
    internal static let fastFood = ImageAsset(name: "fastFood")
    internal static let kexLogo = ImageAsset(name: "kexLogo")
    internal static let location = ImageAsset(name: "location")
    internal static let logo = ImageAsset(name: "logo")
    internal static let marker = ImageAsset(name: "marker")
    internal static let menu = ImageAsset(name: "menu")
    internal static let profile = ImageAsset(name: "profile")
    internal static let search = ImageAsset(name: "search")
    internal static let shareToInstagram = ImageAsset(name: "shareToInstagram")
    internal enum Support {
        internal static let insta = ImageAsset(name: "insta")
        internal static let mail = ImageAsset(name: "mail")
        internal static let tiktok = ImageAsset(name: "tiktok")
        internal static let vk = ImageAsset(name: "vk")
    }

    internal static let support = ImageAsset(name: "support")
}

// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
    internal fileprivate(set) var name: String

    #if os(macOS)
        internal typealias Color = NSColor
    #elseif os(iOS) || os(tvOS) || os(watchOS)
        internal typealias Color = UIColor
    #endif

    @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
    internal private(set) lazy var color: Color = {
        guard let color = Color(asset: self) else {
            fatalError("Unable to load color asset named \(name).")
        }
        return color
    }()

    fileprivate init(name: String) {
        self.name = name
    }
}

internal extension ColorAsset.Color {
    @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
    convenience init?(asset: ColorAsset) {
        let bundle = BundleToken.bundle
        #if os(iOS) || os(tvOS)
            self.init(named: asset.name, in: bundle, compatibleWith: nil)
        #elseif os(macOS)
            self.init(named: NSColor.Name(asset.name), bundle: bundle)
        #elseif os(watchOS)
            self.init(named: asset.name)
        #endif
    }
}

internal struct ImageAsset {
    internal fileprivate(set) var name: String

    #if os(macOS)
        internal typealias Image = NSImage
    #elseif os(iOS) || os(tvOS) || os(watchOS)
        internal typealias Image = UIImage
    #endif

    internal var image: Image {
        let bundle = BundleToken.bundle
        #if os(iOS) || os(tvOS)
            let image = Image(named: name, in: bundle, compatibleWith: nil)
        #elseif os(macOS)
            let name = NSImage.Name(self.name)
            let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
        #elseif os(watchOS)
            let image = Image(named: name)
        #endif
        guard let result = image else {
            fatalError("Unable to load image asset named \(name).")
        }
        return result
    }
}

internal extension ImageAsset.Image {
    @available(macOS, deprecated,
               message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
    convenience init?(asset: ImageAsset) {
        #if os(iOS) || os(tvOS)
            let bundle = BundleToken.bundle
            self.init(named: asset.name, in: bundle, compatibleWith: nil)
        #elseif os(macOS)
            self.init(named: NSImage.Name(asset.name))
        #elseif os(watchOS)
            self.init(named: asset.name)
        #endif
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
