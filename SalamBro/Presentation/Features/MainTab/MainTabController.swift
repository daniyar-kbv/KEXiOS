//
//  MainTabController.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import UIKit

final class SBTabBarController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        view.backgroundColor = .white
        tabBar.tintColor = .kexRed
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        tabBar.itemPositioning = .centered
    }
}

// FIXME: Tech debt, legacy
protocol MainTabDelegate {
    func updateCounter(isIncrease: Bool)
    func setCount(count: Int)
    func changeController(id: Int)
}

//
//// FIXME: Tech debt, legacy
// final class MainTabController: UITabBarController {
//    let coordinator = TabBarCoordinator(navigationController: UINavigationController())
//    var itemCount: Int = 0
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        coordinator.start()
//
//        configureUI()
//        configureViewControllers()
//    }
// }
//
//// FIXME: Tech debt, legacy
// extension MainTabController {
//    func configureUI() {
//        tabBar.barTintColor = .white
//
//        navigationItem.setHidesBackButton(true, animated: true)
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//    }
//
//    func configureViewControllers() {
//        viewControllers = coordinator.getChildNavigationControllers()
//    }
// }
//
//// FIXME: Tech debt, legacy
// extension MainTabController: MainTabDelegate {
//    func getCart() -> CartController? {
//        return coordinator.getCoordinators().first(where: { $0.tabType == .cart })?.childNavigationController.viewControllers.first as? CartController
//    }
//
//    func changeController(id: Int) {
//        selectedIndex = id
//    }
//
//    func setCount(count: Int) {
//        itemCount = count
//        getCart()?.tabBarItem.badgeValue = "\(itemCount)"
//    }
//
//    func updateCounter(isIncrease: Bool) {
//        if isIncrease {
//            itemCount += 1
//        } else if itemCount != 0 {
//            itemCount -= 1
//        }
//        if itemCount != 0 {
//            getCart()?.tabBarItem.badgeValue = "\(itemCount)"
//        } else {
//            getCart()?.tabBarItem.badgeValue = nil
//        }
//    }
// }
