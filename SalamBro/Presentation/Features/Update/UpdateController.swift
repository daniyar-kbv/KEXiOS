//
//  UpdateController.swift
//  SalamBro
//
//  Created by Arystan on 3/7/21.
//

import UIKit

class UpdateController: UIViewController {
    
    fileprivate lazy var rootView = AdditionalView(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func loadView() {
        rootView.descriptionLabel.text = "We added a lot of new features and fixed several bugs for your convenience use".localized()
        rootView.button.setTitle("It's time to update".localized(), for: .normal)
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
    private func updateApp() {
        self.navigationController?.pushViewController(CountriesListController(), animated: true)
    }
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
