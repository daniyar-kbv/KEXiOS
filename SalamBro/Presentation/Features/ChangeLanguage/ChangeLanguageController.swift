//
//  ChangeLanguageController.swift
//  SalamBro
//
//  Created by Arystan on 3/25/21.
//

import SnapKit
import UIKit

class ChangeLanguageController: UIViewController {
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.tintColor = .systemRed
        button.setImage(UIImage(named: "chevron.left"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = L10n.ChangeLanguage.title
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        return view
    }()

    lazy var countriesTableView: UITableView = {
        let table = UITableView()
        table.allowsMultipleSelection = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.tableFooterView = UIView()
        table.separatorInset.right = table.separatorInset.left + table.separatorInset.left
        table.dataSource = self
        table.delegate = self
        return table
    }()

    lazy var separator = SeparatorView()

    fileprivate lazy var selectionIndexPath: IndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    fileprivate func setupViews() {
        view.backgroundColor = .white
        view.addSubview(countriesTableView)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(separator)
    }

    fileprivate func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton.snp.centerY)
        }

        backButton.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(10)
            $0.left.equalToSuperview().offset(18)
            $0.height.width.equalTo(24)
        }

        countriesTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(34)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottomMargin)
        }

        separator.snp.makeConstraints {
            $0.bottom.equalTo(countriesTableView.snp.top)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(0.3)
        }

//        countriesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
//        countriesTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
//        countriesTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
//        countriesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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
                navigationController?.popViewController(animated: true)
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
