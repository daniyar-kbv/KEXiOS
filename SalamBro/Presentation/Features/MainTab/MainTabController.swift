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

class MainTabController: UITabBarController {
    var itemCount: Int = 0

    lazy var menu: MenuController = {
        let viewModel = MenuViewModel(menuRepository: DIResolver.resolve(MenuRepository.self)!)
        let vc = MenuController(viewModel: viewModel)
        vc.tabBarItem.title = L10n.MainTab.Menu.title
        vc.tabBarItem.image = Asset.menu.image
        return vc
    }()

    lazy var profile: ProfileController = {
        let vc = ProfileController()
        vc.tabBarItem.title = L10n.MainTab.Profile.title
        vc.tabBarItem.image = Asset.profile.image
        return vc
    }()

    lazy var support: SupportController = {
        let vc = SupportController()
        vc.tabBarItem.title = L10n.MainTab.Support.title
        vc.tabBarItem.image = Asset.support.image
        return vc
    }()

    lazy var cart: CartController = {
        let vc = CartController()
        vc.mainTabDelegate = self
        vc.tabBarItem.title = L10n.MainTab.Cart.title
        vc.tabBarItem.image = Asset.cart.image
        vc.tabBarItem.badgeColor = .kexRed
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureViewControllers()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension MainTabController {
    func configureUI() {
        view.tintColor = .kexRed
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
}

extension MainTabController: MainTabDelegate {
    func changeController(id: Int) {
        selectedIndex = id
    }

    func setCount(count: Int) {
        itemCount = count
        cart.tabBarItem.badgeValue = "\(itemCount)"
    }

    func updateCounter(isIncrease: Bool) {
        if isIncrease {
            itemCount += 1
        } else if itemCount != 0 {
            itemCount -= 1
        }
        if itemCount != 0 {
            cart.tabBarItem.badgeValue = "\(itemCount)"
        } else {
            cart.tabBarItem.badgeValue = nil
        }
    }
}
