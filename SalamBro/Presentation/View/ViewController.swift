//
//  ViewController.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 11.05.2021.
//

import UIKit

public class ViewController: UIViewController, UIGestureRecognizerDelegate {
    override public func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Asset.chevronLeft.image, style: .plain, target: self, action: #selector(popCurrentViewController))
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()

        if let viewControllers = navigationController?.viewControllers,
           viewControllers.count == 1
        {
            navigationItem.leftBarButtonItem = nil
        }
    }

    @objc private func popCurrentViewController() {
        if navigationController?.presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        }

        navigationController?.popViewController(animated: true)
    }

    internal func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.shadowImage = .init()
        navigationController?.navigationBar.tintColor = .kexRed
        navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: UIColor.black,
        ]
        navigationController?.navigationBar.backIndicatorImage = Asset.chevronLeft.image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = Asset.chevronLeft.image
        navigationItem.title = nil
    }
}
