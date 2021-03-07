//
//  UpdateController.swift
//  SalamBro
//
//  Created by Arystan on 3/7/21.
//

import UIKit

class UpdateController: UIViewController {
    
    fileprivate let movieReusableCell = "movieReusableCell"
    fileprivate lazy var rootView = UpdateView(delegate: self)

    
    override func loadView() {
        view = rootView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
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
        print("proceed to AppStore to update app")
        self.navigationController?.pushViewController(CountriesListController(), animated: true)
    }
}

extension UpdateController: UpdateViewDelegate {
    func update() {
        updateApp()
    }
}

extension UpdateController {
    private func configUI() {
        navigationController?.navigationBar.tintColor = .kexRed
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
