//
//  MainTabController.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import UIKit

final class SBTabBarController: UITabBarController {
    private let viewModel: SBTabBarViewModel
    private var lastViewController: UIViewController?

    init(viewModel: SBTabBarViewModel) {
        self.viewModel = viewModel

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
        delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.getDocuments()
        viewModel.setFirstLauch()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tabBar.isHidden = false
    }
}

extension SBTabBarController: UITabBarControllerDelegate {
    func tabBarController(_: UITabBarController, didSelect viewController: UIViewController) {
        if lastViewController == viewController,
           let scrollView = viewController
           .view
           .getAllSubview()
           .first(where: { $0 is UIScrollView }) as? UIScrollView
        {
            scrollView.setContentOffset(.zero, animated: true)
        }
        lastViewController = viewController
    }
}
