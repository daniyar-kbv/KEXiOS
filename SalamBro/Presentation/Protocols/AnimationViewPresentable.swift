//
//  AnimationViewPresentable.swift
//  SalamBro
//
//  Created by Dan on 7/2/21.
//

import Foundation
import UIKit

protocol AnimationViewPresentable {
    func showAnimationView(delegate: AnimationContainerViewDelegate, animationType: LottieAnimationModel)
}

extension AnimationViewPresentable where Self: UIViewController {
    func showAnimationView(delegate: AnimationContainerViewDelegate,
                           animationType: LottieAnimationModel)
    {
        let animationController = AnimationController(animationType: animationType)
        animationController.delegate = delegate

        addChild(animationController)
        animationController.view.frame = view.frame
        view.addSubview(animationController.view)
        animationController.didMove(toParent: self)
    }

    func hideAnimationView() {
        children.forEach {
            guard let animationController = $0 as? AnimationController else { return }
            animationController.willMove(toParent: nil)
            animationController.view.removeFromSuperview()
            animationController.removeFromParent()
        }
    }
}
