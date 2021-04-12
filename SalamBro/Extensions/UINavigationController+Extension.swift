//
//  UINavigationController+Extension.swift
//  SalamBro
//
//  Created by Arystan on 4/12/21.
//

import UIKit

extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}
