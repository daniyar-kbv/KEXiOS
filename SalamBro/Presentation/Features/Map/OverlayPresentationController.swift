//
//  OverlayControlleer.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/19/21.
//

import UIKit

class OverlayPresentationController: UIPresentationController {
    private let dimmedBackgroundView = UIView()
    private let height: CGFloat = 185.0

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        let backgroundTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        let viewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        dimmedBackgroundView.addGestureRecognizer(backgroundTapGestureRecognizer)
        presentedView?.addGestureRecognizer(viewTapGestureRecognizer)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        var frame = CGRect.zero
        if let containerBounds = containerView?.bounds {
            if getScreenSize() == 0 {
                frame = CGRect(x: 0,
                               y: containerBounds.height - height * 2.3,
                               width: containerBounds.width,
                               height: height)
            } else {
                frame = CGRect(x: 0,
                               y: height * 2,
                               width: containerBounds.width,
                               height: height)
            }
        }
        return frame
    }

    override func presentationTransitionWillBegin() {
        if let containerView = self.containerView, let coordinator = presentingViewController.transitionCoordinator {
            containerView.addSubview(dimmedBackgroundView)
            dimmedBackgroundView.backgroundColor = .black
            dimmedBackgroundView.frame = containerView.bounds
            dimmedBackgroundView.alpha = 0
            coordinator.animate(alongsideTransition: { _ in
                self.dimmedBackgroundView.alpha = 0.5
            }, completion: nil)
        }
    }

    override func dismissalTransitionDidEnd(_: Bool) {
        dimmedBackgroundView.removeFromSuperview()
    }

    @objc func viewTapped() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }

    private func getScreenSize() -> CGFloat {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height

        let indent: CGFloat = height <= 736 ? 0 : 40

        return indent
    }
}
