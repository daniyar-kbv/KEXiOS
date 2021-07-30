//
//  SBNavigationController.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 24.06.2021.
//

import UIKit

enum BarButtonConfiguration {
    case withBackButton
    case none
}

protocol NavigationLogic {
    func configure(viewController: UIViewController, in navigationController: UINavigationController) -> BarButtonConfiguration
}

@objc protocol SBNavigationControllerDelegate: AnyObject {
    func sbNavigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController)
    func sbNavigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController)
}

final class SBNavigationController: UINavigationController, AnimationViewPresentable, AlertDisplayable {
    private var observers = NSHashTable<SBNavigationControllerDelegate>.weakObjects()
    private var numberOfVCs: Int

    override init(rootViewController: UIViewController) {
        numberOfVCs = 1
        super.init(rootViewController: rootViewController)
        delegate = self
        navigationDefaultAppearance()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        numberOfVCs = 1
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        delegate = self
        navigationDefaultAppearance()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addObserver(_ observer: SBNavigationControllerDelegate) {
        observers.add(observer)
    }

    func removeObserver(_ observer: SBNavigationControllerDelegate) {
        observers.remove(observer)
    }

    private func navigationDefaultAppearance() {
        setNavigationBarHidden(false, animated: true)
        navigationBar.shadowImage = .init()
        navigationBar.setBackgroundImage(.init(), for: .default)
        navigationBar.backgroundColor = .clear
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold),
        ]
        navigationBar.titleTextAttributes = textAttributes
        navigationBar.isTranslucent = false
    }
}

extension SBNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated _: Bool) {
        let willPush: Bool = numberOfVCs < navigationController.viewControllers.count
        numberOfVCs = navigationController.viewControllers.count

        if willPush {
            observers.allObjects.last?.sbNavigationController(navigationController, willShow: viewController)
        } else {
            observers.allObjects.forEach {
                $0.sbNavigationController(navigationController, willShow: viewController)
            }
        }
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated _: Bool) {
        observers.allObjects.forEach {
            $0.sbNavigationController(navigationController, didShow: viewController)
        }
    }
}
