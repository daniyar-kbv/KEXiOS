//
//  ChangeLanguageController.swift
//  SalamBro
//
//  Created by Arystan on 3/25/21.
//

import UIKit

class ChangeLanguageController: UIViewController {
    
    fileprivate lazy var rootView = ChangeLanguageView(delegate: self)
    fileprivate lazy var selectionIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func loadView() {
        view = rootView
    }
    
}

//MARK: - UITableView
extension ChangeLanguageController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = languages[indexPath.row]
        cell.backgroundColor = .white
        cell.tintColor = .kexRed
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectionIndexPath != nil {
            if selectionIndexPath == indexPath {
//                selectionIndexPath = nil
                self.navigationController?.popViewController(animated: true)
            } else {
                selectionIndexPath = indexPath
                let cell = tableView.cellForRow(at: selectionIndexPath!)
                cell?.accessoryType = .checkmark
            }
        } else {
            selectionIndexPath = indexPath
            let cell = tableView.cellForRow(at: selectionIndexPath!)
            cell?.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
    
}

extension ChangeLanguageController: ChangeLanguaeViewDelegate {
    func updateList() {
        print("update list...")
    }
}

extension ChangeLanguageController {
    private func configUI() {
        parent?.navigationItem.title = L10n.ChangeLanguage.NavigationBar.title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

