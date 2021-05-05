//
//  SupportController.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import SnapKit
import UIKit

class SupportController: UIViewController {
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Помощь"
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        return view
    }()

    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .mildBlue
        return view
    }()

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.estimatedRowHeight = 50
        view.tableFooterView = UIView()
        view.delegate = self
        view.dataSource = self
        view.bounces = false
        view.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        return view
    }()

    lazy var logoStack: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.axis = .horizontal
        view.spacing = 20
        return view
    }()

    lazy var callButton: UIButton = {
        let button = UIButton()
        button.setTitle("Позвонить в Call-центр", for: .normal)
        button.setTitleColor(.kexRed, for: .normal)
        button.addTarget(self, action: #selector(call), for: .touchUpInside)
        button.borderWidth = 1
        button.borderColor = .kexRed
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func setupViews() {
        ["insta", "tiktok", "mail", "vk"].forEach { logoStack.addArrangedSubview(UIImageView(image: UIImage(named: $0))) }
        [titleLabel, separator, tableView, logoStack, callButton].forEach { view.addSubview($0) }
    }

    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(12)
            $0.centerX.equalToSuperview()
        }

        separator.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(34)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(1)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalTo(logoStack.snp.top).offset(-16)
        }

        logoStack.snp.makeConstraints {
            $0.bottom.equalTo(callButton.snp.top).offset(-64)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
        }

        callButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalTo(view.snp.bottomMargin).offset(-32)
            $0.height.equalTo(43)
        }
    }

    @objc func call() {
        print("call-center")
    }
}

extension SupportController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0, indexPath.row == 0 {
            navigationController?.pushViewController(AgreementController(), animated: true)
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0, indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.text = L10n.Agreement.Navigation.title
            cell.imageView?.image = UIImage(named: "documents")
            return cell
        }
        return UITableViewCell()
    }
}
