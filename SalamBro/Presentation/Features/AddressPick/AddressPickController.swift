//
//  AddressPickController.swift
//  SalamBro
//
//  Created by Arystan on 5/4/21.
//

import UIKit

class AddressPickController: UIViewController {
    @IBOutlet var addressPickView: UIView!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        tableView.tableFooterView = UIView()
    }
}

extension AddressPickController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "Алматы, мкр. Орбита 1, 41"
            cell.tintColor = .kexRed
            cell.accessoryType = .checkmark
        } else {
            cell.textLabel?.text = "Алматы, мкр. Орбита 2, 28"
            cell.tintColor = .mildBlue
            cell.accessoryType = .disclosureIndicator
        }
        cell.selectionStyle = .none
        return cell
    }
}
