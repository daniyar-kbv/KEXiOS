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

extension ProfileController: ProfileViewDelegate {
    func changeName() {
        navigationController?.pushViewController(ChangeNameController(), animated: true)
    }

    func logout() {
        print("logout action")
    }
}

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
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

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationController?.pushViewController(OrderHistoryController(), animated: true)
        } else {
            navigationController?.pushViewController(ChangeLanguageController(), animated: true)
        }
    }
}
