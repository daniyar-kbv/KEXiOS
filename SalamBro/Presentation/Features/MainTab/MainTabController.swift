//
//  MainTabController.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import UIKit

protocol MainTabDelegate {
    func updateCounter(isIncrease: Bool)
    func setCount(count: Int)
    func changeController(id: Int)
}

final class MainTabController: UITabBarController {
    let coordinator = TabBarCoordinator(navigationController: UINavigationController())
    var itemCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinator.start()
        
        configureUI()
        configureViewControllers()
    }
}

extension MainTabController {
    func configureUI() {
        view.tintColor = .kexRed
        tabBar.barTintColor = .white

        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    func configureViewControllers() {
        viewControllers = coordinator.getChildNavigationControllers()
    }
}

extension MainTabController: MainTabDelegate {
    func getCart() -> CartController? {
        return coordinator.getCoordinators().first(where: { $0.tabType == .cart })?.childNavigationController.viewControllers.first as? CartController
    }
    
    func changeController(id: Int) {
        selectedIndex = id
    }

    func setCount(count: Int) {
        itemCount = count
        getCart()?.tabBarItem.badgeValue = "\(itemCount)"
    }

    func updateCounter(isIncrease: Bool) {
        if isIncrease {
            itemCount += 1
        } else if itemCount != 0 {
            itemCount -= 1
        }
        if itemCount != 0 {
            getCart()?.tabBarItem.badgeValue = "\(itemCount)"
        } else {
            getCart()?.tabBarItem.badgeValue = nil
        }
    }
}
