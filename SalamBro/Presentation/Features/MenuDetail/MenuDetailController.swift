//
//  MenuDetailController.swift
//  SalamBro
//
//  Created by Arystan on 5/3/21.
//

import Reusable
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class MenuDetailController: UIViewController {
    private var viewModel: MenuDetailViewModelProtocol
    private let disposeBag: DisposeBag

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = Asset.fastFood.image
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var itemTitleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var commentaryView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        let tap = UIGestureRecognizer(target: self, action: #selector(commentaryViewTapped))
        view.addGestureRecognizer(tap)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var chooseAdditionalItemView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var chooseAdditionalItemLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.text = "Choose item"
        view.textColor = .systemGray
        view.font = .systemFont(ofSize: 14)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var additionalItemLabel: UILabel = {
        let view = UILabel()
        view.text = "Cola 0.5"
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var chooseAdditionalItemButton: UIButton = {
        let view = UIButton()
        view.setTitle("Change", for: .normal)
        view.setTitleColor(.systemRed, for: .normal)
        view.addTarget(self, action: #selector(additionalItemChangeButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var commentaryField: UITextField = {
        let view = UITextField()
        view.placeholder = "Commentary"
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var proceedButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .systemRed
        view.setTitle("Add to cart", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.tintColor = .systemRed
        button.setImage(Asset.back.image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    public init(viewModel: MenuDetailViewModelProtocol) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { nil }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func bind() {
        viewModel.itemTitle
            .bind(to: itemTitleLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.itemDescription
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.itemPrice
            .bind(to: proceedButton.rx.title())
            .disposed(by: disposeBag)
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .white

        [chooseAdditionalItemLabel, additionalItemLabel, chooseAdditionalItemButton].forEach { chooseAdditionalItemView.addSubview($0) }
        commentaryView.addSubview(commentaryField)
        [imageView, itemTitleLabel, descriptionLabel, chooseAdditionalItemView, commentaryView, proceedButton, backButton].forEach { view.addSubview($0) }
    }

    func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(8)
            $0.left.equalToSuperview().offset(39)
            $0.right.equalToSuperview().offset(-38)
            $0.height.equalTo(216)
        }

        itemTitleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(27)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(itemTitleLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }

        chooseAdditionalItemLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }

        additionalItemLabel.snp.makeConstraints {
            $0.top.equalTo(chooseAdditionalItemLabel.snp.bottom).offset(3)
            $0.left.equalToSuperview()
            $0.right.equalTo(chooseAdditionalItemButton.snp.left).offset(-8)
            $0.bottom.equalToSuperview()
        }

        chooseAdditionalItemButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalTo(additionalItemLabel.snp.centerY)
        }

        chooseAdditionalItemView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(36)
        }

        commentaryField.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }

        commentaryView.snp.makeConstraints {
            $0.top.equalTo(chooseAdditionalItemView.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(50)
        }

        proceedButton.snp.makeConstraints {
            $0.top.equalTo(commentaryView.snp.bottom).offset(32)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(43)
        }

        backButton.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(22)
            $0.left.equalToSuperview().offset(18)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
    }

    @objc func additionalItemChangeButtonTapped() {
        print("additionalItemChangeButtonTapped")
    }

    @objc func commentaryViewTapped(_: UIGestureRecognizer) {
        print("commentaryViewTapped")
    }

    @objc func backButtonTapped(_: UIButton!) {
        print("go back")
        dismiss(animated: true, completion: nil)
    }
}
