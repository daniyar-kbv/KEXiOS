//
//  AnimationViewPresentable.swift
//  SalamBro
//
//  Created by Dan on 7/2/21.
//

import Foundation
import UIKit

protocol AnimationViewPresentable {
    func showAnimationView(animationType: LottieAnimationModel, action: (() -> Void)?)
    func getAnimationView(animationType: LottieAnimationModel) -> UIView
    func hideAnimationView(completionHandler: (() -> Void)?)

    func presentAnimationView(animationType: LottieAnimationModel, action: (() -> Void)?)
    func dismissAnimationView(completionHandler: (() -> Void)?)
}

extension UIViewController: AnimationViewPresentable {
    func showAnimationView(animationType: LottieAnimationModel, action: (() -> Void)?) {
        guard needsShow() else { return }

        let animationController = AnimationController(animationType: animationType)
        animationController.action = action

        addChild(animationController)
        view.addSubview(animationController.view)
        animationController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        animationController.didMove(toParent: self)
    }

    func getAnimationView(animationType: LottieAnimationModel) -> UIView {
        let animationView = AnimationContainerView(animationType: animationType)
        animationView.animationPlay()
        return animationView
    }

    func hideAnimationView(completionHandler _: (() -> Void)?) {
        let animationController = children.first(where: { $0 is AnimationController }) as? AnimationController

        animationController?.willMove(toParent: nil)
        animationController?.view.removeFromSuperview()
        animationController?.removeFromParent()
    }

    private func needsShow() -> Bool {
        return !children.contains(where: { $0 is AnimationController })
    }

    func presentAnimationView(animationType: LottieAnimationModel,
                              action: (() -> Void)?)
    {
        guard needsPresentation() else { return }

        let animationController = AnimationController(animationType: animationType)
        animationController.action = action
        animationController.modalPresentationStyle = .fullScreen

        guard let presentedViewController = presentedViewController else {
            present(animationController, animated: false)
            return
        }

        presentedViewController.dismiss(animated: false, completion: {
            self.present(animationController, animated: false)
        })
    }

    func dismissAnimationView(completionHandler: (() -> Void)? = nil) {
        presentedViewController?.dismiss(animated: false, completion: completionHandler)
    }

    private func needsPresentation() -> Bool {
        return (presentedViewController as? AnimationController) == nil
    }
}
