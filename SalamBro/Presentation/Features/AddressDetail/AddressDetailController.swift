//
//  AddressDetailController.swift
//  SalamBro
//
//  Created by Arystan on 5/7/21.
//

import UIKit

class AddressDetailController: UIViewController {
    private lazy var navbar = CustomNavigationBarView(navigationTitle: L10n.AddressPicker.title)

    lazy var deleteButton: UIButton = {
        let view = UIButton()
        view.tintColor = .kexRed
        view.setImage(UIImage(named: "trash"), for: .normal)
        view.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return view
    }()

    lazy var addressTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .mildBlue
        view.text = L10n.AddressPicker.title
        view.font = .systemFont(ofSize: 10, weight: .medium)
        return view
    }()

    lazy var addressLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        return view
    }()

    lazy var commentaryTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .mildBlue
        view.font = .systemFont(ofSize: 10, weight: .medium)
        view.text = "Комментарий"
        return view
    }()

    lazy var commentaryLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .white
        navbar.addSubview(deleteButton)
        [addressLabel, addressTitleLabel, commentaryLabel, commentaryTitleLabel, navbar].forEach { view.addSubview($0) }
        navbar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navbar.titleLabel.font = .systemFont(ofSize: 26, weight: .regular)
    }

    private func setupConstraints() {
        deleteButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }

        navbar.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }

        addressTitleLabel.snp.makeConstraints {
            $0.top.equalTo(navbar.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }

        addressLabel.snp.makeConstraints {
            $0.top.equalTo(addressTitleLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }

        commentaryTitleLabel.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }

        commentaryLabel.snp.makeConstraints {
            $0.top.equalTo(commentaryTitleLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc func deleteAction() {
        let alert = UIAlertController(title: "Вы уверены?", message: "Вы уверены что хотите удалить адрес доставки?", preferredStyle: .alert)
        alert.view.tintColor = .kexRed
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            switch action.style {
            case .default:
                print("default")

            case .cancel:
                print("cancel")

            case .destructive:
                print("destructive")
            }
        }))

        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: { action in
            switch action.style {
            case .default:
                print("default")

            case .cancel:
                print("cancel")

            case .destructive:
                print("destructive")
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
