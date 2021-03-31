//
//  MainTabController.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import UIKit

class MainTabController: UITabBarController {
    
    var itemCount: Int = 0
    
    lazy var menu: MenuController = {
        let vc = MenuController()
        vc.tabBarItem.title = L10n.MainTab.Menu.title
        vc.tabBarItem.image = UIImage(named: "menu")
        return vc
    }()
    
    lazy var profile: ProfileController = {
        let vc = ProfileController()
        vc.tabBarItem.title = L10n.MainTab.Profile.title
        vc.tabBarItem.image = UIImage(named: "profile")
        vc.navigationController?.title = "X"
        return vc
    }()
    
    lazy var support: SupportController = {
        let vc = SupportController()
        vc.tabBarItem.title = L10n.MainTab.Support.title
        vc.tabBarItem.image = UIImage(named: "support")
        return vc
    }()
    
    lazy var cart: CartController = {
        let vc = CartController()
        vc.tabBarItem.title = L10n.MainTab.Cart.title
        vc.tabBarItem.image = UIImage(named: "cart")
        vc.tabBarItem.badgeColor = .kexRed
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureViewControllers()
    }

}

extension MainTabController {
    func configureUI() {
        view.tintColor = .kexRed
        navigationItem.setHidesBackButton(true, animated: true)
    }

    func configureViewControllers() {
        let controllers = [menu, profile, support, cart]
        viewControllers = controllers
    }

    func templateNavigationController(title: String, image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.navigationBar.tintColor = .white
        return nav
    }
    
    func updateCounter(isIncrease: Bool) {
        if isIncrease {
            itemCount += 1
        } else if itemCount != 0 {
            itemCount -= 1
        }
        cart.tabBarItem.badgeValue = itemCount.description
    }
}
