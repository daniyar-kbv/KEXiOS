//
//  Router.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 10.05.2021.
//

import Foundation

import UIKit

public protocol Router: AnyObject {
    var baseViewController: UIViewController? { get set }

    func present(on baseVC: UIViewController, animated: Bool, context: Any?, completion: (() -> Void)?)
    func enqueueRoute(with context: Any?, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

public extension Router {
    func present(on baseVC: UIViewController, context: Any?) {
        present(on: baseVC, animated: true, context: context, completion: nil)
    }

    func enqueueRoute(with context: Any?) {
        enqueueRoute(with: context, animated: true, completion: nil)
    }

    func enqueueRoute(with context: Any?, completion: (() -> Void)?) {
        enqueueRoute(with: context, animated: true, completion: completion)
    }

    func dismiss(animated: Bool = true) {
        dismiss(animated: animated, completion: nil)
    }

    func alert(error: Error, closeHandler: (() -> Void)? = nil) {
        guard let baseVC = baseViewController else { return }
        let router = AlertRouter()
        let context = AlertRouter.PresentationContext.error(message: error.localizedDescription, closeHandler: closeHandler)
        router.present(on: baseVC, animated: true, context: context, completion: nil)
    }

    func alert(title: String, message: String, closeHandler: (() -> Void)? = nil) {
        guard let baseVC = baseViewController else { return }
        let router = AlertRouter()
        let context = AlertRouter.PresentationContext.default(title: title, message: message, closeHandler: closeHandler)
        router.present(on: baseVC, animated: true, context: context, completion: nil)
    }
}
