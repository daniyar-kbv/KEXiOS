//
//  ViewController.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 11.05.2021.
//

import UIKit

public class ViewController: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()

        guard navigationController?.presentingViewController != nil,
              navigationController?.viewControllers.count == 1
        else {
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationItem.leftBarButtonItem = nil
            return
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Asset.chevronLeft.image, style: .plain, target: self, action: #selector(popCurrentViewController))
    }

    @objc private func popCurrentViewController() {
        dismiss(animated: true, completion: nil)
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
        navigationItem.title = nil
    }
}
