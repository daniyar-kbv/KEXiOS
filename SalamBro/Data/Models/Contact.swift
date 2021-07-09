//
//  Contact.swift
//  SalamBro
//
//  Created by Dan on 6/24/21.
//

import Foundation
import UIKit

struct Contact: Codable {
    let name: String
    let value: String
}

extension Contact {
    func getType() -> Type? {
        return Type(rawValue: name)
    }

    func getURL() -> URL? {
        switch getType() {
        case .instagram:
            return URL(string: "https://www.instagram.com/\(value)/")
        case .tiktok:
            return URL(string: "https://www.tiktok.com/@\(value)")
        case .email:
            return URL(string: "mailto:\(value)")
        case .vk:
            return URL(string: value)
        case .callCenter:
            return URL(string: "tel://\(value)")
        default:
            return nil
        }
    }

    enum `Type`: String {
        case instagram = "INSTAGRAM"
        case tiktok = "TIKTOK"
        case email = "EMAIL"
        case vk = "VK"
        case callCenter = "CALL_CENTER_PHONE"

        var image: UIImage? {
            switch self {
            case .instagram: return SBImageResource.getIcon(for: SupportIcons.Support.instagramIcon)
            case .tiktok: return SBImageResource.getIcon(for: SupportIcons.Support.tikTokIcon)
            case .email: return SBImageResource.getIcon(for: SupportIcons.Support.mailIcon)
            case .vk: return SBImageResource.getIcon(for: SupportIcons.Support.vkIcon)
            case .callCenter: return nil
            }
        }
    }
}
