//
//  AlertRouter.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 10.05.2021.
//

import UIKit

public final class AlertHandler {
    public enum AlertType {
        case `default`(title: String, message: String?, closeHandler: (() -> Void)?)
        case error(message: String?, closeHandler: (() -> Void)?)

        var attributedTitle: NSAttributedString {
            switch self {
            case let .default(title, _, _):
                return NSAttributedString(string: title,
                                          attributes: Constant.Attributes.title)
            case .error:
                return NSAttributedString(string: Constant.Title.error,
                                          attributes: Constant.Attributes.title)
            }
        }

        var attributedMessage: NSAttributedString? {
            switch self {
            case let .default(_, message, _):
                guard let message = message else { return nil }
                return NSAttributedString(string: message, attributes: Constant.Attributes.message)
            case let .error(message, _):
                guard let message = message else { return nil }
                return NSAttributedString(string: message, attributes: Constant.Attributes.message)
            }
        }

        var closeHandler: (() -> Void)? {
            switch self {
            case let .default(_, _, closeHandler):
                return closeHandler
            case let .error(_, closeHandler):
                return closeHandler
            }
        }
    }

    private enum Constant {
        enum Title {
            static let close = L10n.Common.close
            static let error = L10n.Common.error
        }

        enum Attributes {
            static let title: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold),
                NSAttributedString.Key.foregroundColor: UIColor.black,
            ]
            static let message: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.black,
            ]
        }
    }

    public func present(on baseVC: UIViewController, animated: Bool, alertType: AlertType, completion _: (() -> Void)?) {
        let alert = constructAttributedAlert(alertType: alertType)

        baseVC.present(alert, animated: animated)
    }

    private func constructAttributedAlert(alertType: AlertType) -> UIAlertController {
        let actions: [UIAlertAction] = [
            UIAlertAction(title: Constant.Title.close, style: .default) { _ in
                DispatchQueue.main.async {
                    alertType.closeHandler?()
                }
            },
        ]

        let alert = UIAlertController(
            attributedTitle: alertType.attributedTitle,
            attributedMessage: alertType.attributedMessage,
            preferredStyle: .alert,
            actions: actions
        )

        alert.view.tintColor = .kexRed

        return alert
    }
}
