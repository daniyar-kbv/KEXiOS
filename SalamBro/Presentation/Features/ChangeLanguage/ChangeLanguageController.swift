//
//  ChangeLanguageController.swift
//  SalamBro
//
//  Created by Arystan on 3/25/21.
//

import SnapKit
import UIKit

class ChangeLanguageController: ViewController {
    lazy var countriesTableView: UITableView = {
        let table = UITableView()
        table.allowsMultipleSelection = false
        table.separatorColor = .mildBlue
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.tableFooterView = UIView()
        table.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        table.dataSource = self
        table.delegate = self
        table.addTableHeaderViewLine()
        return table
    }()

    fileprivate lazy var selectionIndexPath: IndexPath? = nil

    private var marked: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = L10n.ChangeLanguage.title
    }

    fileprivate func setupViews() {
        view.backgroundColor = .white
        view.addSubview(countriesTableView)
    }

    fileprivate func setupConstraints() {
        countriesTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableView

extension ChangeLanguageController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        50
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return languages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = languages[indexPath.row]
        cell.backgroundColor = .white
        cell.tintColor = .kexRed
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.imageView?.image = UIImage(named: "kazakh")
        case 1:
            cell.imageView?.image = UIImage(named: "russian")
            cell.accessoryView = checkmark
            marked = indexPath
        case 2:
            cell.imageView?.image = UIImage(named: "english")
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectionIndexPath != nil {
            if selectionIndexPath == indexPath {
//                selectionIndexPath = nil
            } else {
                selectionIndexPath = indexPath
                let cell = tableView.cellForRow(at: selectionIndexPath!)
                cell?.accessoryView = checkmark
            }
        } else {
            selectionIndexPath = indexPath
            let cell = tableView.cellForRow(at: selectionIndexPath!)
            tableView.cellForRow(at: marked!)?.accessoryView = .none
            cell?.accessoryView = checkmark
            marked = indexPath
        }
        navigationController?.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryView = .none
    }
}
