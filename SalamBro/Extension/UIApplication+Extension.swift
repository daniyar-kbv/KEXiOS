//
//  UIApplication+Extension.swift
//  SalamBro
//
//  Created by Dan on 6/1/21.
//

import Foundation
import UIKit

extension UIApplication {
    func setRootView(_ vc: UIViewController, completion: (() -> Void)? = nil) {
        guard let window = keyWindow else { return }
        window.rootViewController = vc
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil)
        { _ in
            completion?()
        }
    }

    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }

        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }

        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
