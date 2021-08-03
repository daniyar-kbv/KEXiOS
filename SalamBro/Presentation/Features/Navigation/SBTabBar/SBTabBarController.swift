//
//  MainTabController.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import UIKit

final class SBTabBarController: UITabBarController, AnimationViewPresentable, AlertDisplayable {
    private let viewModel: SBTabBarViewModel

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
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.getDocuments()
        viewModel.refreshToken()
        viewModel.setFirstLauch()
    }
}
