//
//  AnimationViewPresentable.swift
//  SalamBro
//
//  Created by Dan on 7/2/21.
//

import Foundation
import UIKit

protocol AnimationViewPresentable {
    func showAnimationView(animationType: LottieAnimationModel,
                           fullScreen: Bool,
                           action: (() -> Void)?)
}

extension AnimationViewPresentable where Self: UIViewController {
    func showAnimationView(animationType: LottieAnimationModel,
                           fullScreen: Bool,
                           action: (() -> Void)? = nil)
    {
        guard needsPresentation() else { return }

        let animationController = AnimationController(animationType: animationType)
        animationController.action = action
        animationController.modalPresentationStyle = fullScreen ? .fullScreen : .currentContext

        guard let presentedViewController = presentedViewController else {
            present(animationController, animated: false)
            return
        }

        presentedViewController.dismiss(animated: false, completion: {
            self.present(animationController, animated: false)
        })
    }

    func hideAnimationView(_ completionHandler: (() -> Void)? = nil) {
        presentedViewController?.dismiss(animated: false, completion: completionHandler)
    }

    private func needsPresentation() -> Bool {
        return !children.contains(where: { $0 is AnimationController })
    }
}
