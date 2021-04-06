//
//  ProfileController.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import UIKit

class ProfileController: UIViewController {

    fileprivate lazy var rootView = ProfileView(delegate: self)
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        parent?.navigationController?.title = L10n.Profile.NavigationBar.title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension ProfileController: ProfileViewDelegate {
    func changeName() {
        self.navigationController?.pushViewController(ChangeNameController(), animated: true)
    }
    
    func logout() {
        print("logout action")
    }
}

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = profileItems[indexPath.row]
        cell.tintColor = .kexRed
        cell.selectionStyle = .none
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(OrderHistoryController(), animated: true)
        } else {
            self.navigationController?.pushViewController(ChangeLanguageController(), animated: true)
        }
    }
    
}

