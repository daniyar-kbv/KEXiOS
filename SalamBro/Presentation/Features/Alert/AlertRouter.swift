//
//  AlertRouter.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 10.05.2021.
//

import UIKit

public final class AlertRouter: Router {
    public enum PresentationContext {
        case `default`(title: String, message: String?, closeHandler: (() -> Void)?)
        case error(message: String?, closeHandler: (() -> Void)?)
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
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            ]
        }

        enum Key {
            static let attributedTitle = "attributedTitle"
            static let attributedMessage = "attributedMessage"
        }
    }

    public weak var baseViewController: UIViewController?

    public func present(on baseVC: UIViewController, animated: Bool, context: Any?, completion _: (() -> Void)?) {
        guard let context = context as? PresentationContext else {
            assertionFailure("The context type mismatch")
            return
        }

        baseViewController = baseVC

        switch context {
        case let .default(title, message, closeHandler):
            let alertC = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            let titleAttributedString = NSMutableAttributedString(string: title,
                                                                  attributes: Constant.Attributes.title)
            if let message = message {
                titleAttributedString.append(NSAttributedString(string: "\n\(message)",
                                                                attributes: Constant.Attributes.message))
            }

            alertC.setValue(titleAttributedString, forKey: Constant.Key.attributedTitle)
            alertC.view.tintColor = .kexRed
            alertC.addAction(UIAlertAction(title: Constant.Title.close, style: .default) { _ in
                DispatchQueue.main.async {
                    closeHandler?()
                }
            })

            baseVC.present(alertC, animated: animated)
        case let .error(message, closeHandler):
            let alertC = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            let titleAttributedString = NSMutableAttributedString(string: Constant.Title.error,
                                                                  attributes: Constant.Attributes.title)
            if let message = message {
                titleAttributedString.append(NSAttributedString(string: "\n\(message)",
                                                                attributes: Constant.Attributes.message))
            }

            alertC.setValue(titleAttributedString, forKey: Constant.Key.attributedTitle)
            alertC.view.tintColor = .kexRed
            alertC.addAction(UIAlertAction(title: Constant.Title.close, style: .default) { _ in
                DispatchQueue.main.async {
                    closeHandler?()
                }
            })

            baseVC.present(alertC, animated: animated)
        }
    }

    public func enqueueRoute(with _: Any?, animated _: Bool, completion _: (() -> Void)?) {}

    public func dismiss(animated _: Bool, completion _: (() -> Void)?) {}
}
