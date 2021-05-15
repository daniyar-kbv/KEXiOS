//
//  UpdateController.swift
//  SalamBro
//
//  Created by Arystan on 3/7/21.
//

import UIKit

class UpdateController: ViewController {
    lazy var rootView = AdditionalView(delegate: self, descriptionTitle: L10n.Update.Title.description, buttonTitle: L10n.Update.Button.title, image: UIImage(named: "logo")!)

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    override func loadView() {
        view = rootView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - Actions

extension UpdateController {
    private func updateApp() {}
}

extension UpdateController: AdditionalViewDelegate {
    func action() {
        updateApp()
    }
}

extension UpdateController {
    private func configUI() {
        navigationController?.navigationBar.tintColor = .kexRed
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
