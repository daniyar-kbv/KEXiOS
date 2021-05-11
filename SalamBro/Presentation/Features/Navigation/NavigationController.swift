//
//  NavigationController.swift
//  SalamBro
//
//  Created by Arystan on 5/9/21.
//

import UIKit

public final class NavigationController: UINavigationController, UINavigationControllerDelegate {
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.chevronLeft.image, for: .normal)
        button.tintColor = .kexRed
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()

    override public func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        if viewControllers.count == 1,
           let vc = viewControllers.first as? ViewController,
           vc.shouldShowBackItem
        {
            viewControllers.first?.navigationItem.leftBarButtonItem = .init(customView: closeButton)
        } else {
            viewControllers.last?.navigationItem.leftBarButtonItem = nil
        }
    }

    override public func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        if viewControllers.count == 1,
           let vc = viewControllers.first as? ViewController,
           vc.shouldShowBackItem
        {
            viewControllers.first?.navigationItem.leftBarButtonItem = .init(customView: closeButton)
        } else {
            viewControllers.last?.navigationItem.leftBarButtonItem = nil
        }
        return vc
    }

    @objc
    private func close() {
        dismiss(animated: true)
    }
}
