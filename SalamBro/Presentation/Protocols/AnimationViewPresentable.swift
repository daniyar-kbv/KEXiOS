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
        guard needsPresentation() else { return }

        let animationController = AnimationController(animationType: animationType)
        animationController.delegate = delegate

        addChild(animationController)
        view.addSubview(animationController.view)
        animationController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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

    private func needsPresentation() -> Bool {
        return !children.contains(where: { $0 is AnimationController })
    }
}
