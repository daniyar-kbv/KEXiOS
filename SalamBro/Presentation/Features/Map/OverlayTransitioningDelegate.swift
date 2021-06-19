//
//  OverlayTransitionDelegate.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/19/21.
//

import UIKit

class OverlayTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source _: UIViewController) -> UIPresentationController? {
        return OverlayPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
