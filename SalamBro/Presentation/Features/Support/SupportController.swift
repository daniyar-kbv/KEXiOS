//
//  SupportController.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import SnapKit
import UIKit

class SupportController: ViewController {
    var coordinator: SupportCoordinator

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorColor = .mildBlue
        view.addTableHeaderViewLine()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.estimatedRowHeight = 50
        view.tableFooterView = UIView()
        view.delegate = self
        view.dataSource = self
        view.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        return view
    }()

    lazy var instagramView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "insta")
        view.isUserInteractionEnabled = true
        let tap = CustomTapGestureRecognizer(target: self, action: #selector(imagePressed(sender:)))
        tap.source = "insta"
        view.addGestureRecognizer(tap)
        return view
    }()

    lazy var tiktokView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "tiktok")
        view.isUserInteractionEnabled = true
        let tap = CustomTapGestureRecognizer(target: self, action: #selector(imagePressed(sender:)))
        tap.source = "tiktok"
        view.addGestureRecognizer(tap)
        return view
    }()

    lazy var mailView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "mail")
        view.isUserInteractionEnabled = true
        let tap = CustomTapGestureRecognizer(target: self, action: #selector(imagePressed(sender:)))
        tap.source = "mail"
        view.addGestureRecognizer(tap)
        return view
    }()

    lazy var vkView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "vk")
        view.isUserInteractionEnabled = true
        let tap = CustomTapGestureRecognizer(target: self, action: #selector(imagePressed(sender:)))
        tap.source = "vk"
        view.addGestureRecognizer(tap)
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
        button.setTitle(L10n.Support.callcenter, for: .normal)
        button.setTitleColor(.kexRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(call), for: .touchUpInside)
        button.borderWidth = 1
        button.borderColor = .kexRed
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()

    init(coordinator: SupportCoordinator) {
        self.coordinator = coordinator

        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = L10n.Support.title
    }

    func setupViews() {
        [instagramView, tiktokView, mailView, vkView].forEach { logoStack.addArrangedSubview($0) }
        [tableView, logoStack, callButton].forEach { view.addSubview($0) }
    }

    func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(34)
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
            $0.bottom.equalTo(view.snp.bottomMargin).offset(-24)
            $0.height.equalTo(43)
        }
    }

    @objc func imagePressed(sender: CustomTapGestureRecognizer) {
        var url = ""
        switch sender.source {
        case "insta":
            url = "https://www.instagram.com/kex_brands/"
        case "tiktok":
            url = "https://www.tiktok.com/@kex.house"
        case "mail":
            url = "mailto:info@kexbrands.kz"
            let appURL = URL(string: url)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL)
            }
            return
        case "vk":
            url = "https://www.vk.com"
        default:
            break
        }

        if let url = URL(string: url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    @objc func call() {
        if let url = URL(string: "tel://5888"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

extension SupportController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0, indexPath.row == 0 {
            coordinator.openAgreement()
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0, indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.text = L10n.Support.documents
            cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            cell.imageView?.image = UIImage(named: "documents")
            return cell
        }
        return UITableViewCell()
    }
}

class CustomTapGestureRecognizer: UITapGestureRecognizer {
    var source: String?
}
