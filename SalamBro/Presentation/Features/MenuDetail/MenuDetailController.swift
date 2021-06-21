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

final class MenuDetailController: UIViewController {
    private var viewModel: MenuDetailViewModelProtocol
    private let disposeBag: DisposeBag

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = Asset.fastFood.image
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.text = "Чизбургер куриный"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = "Чизбургер куриный"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var commentaryView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.commetaryViewTapped(_:)))
        view.addGestureRecognizer(tap)

        return view
    }()

    private lazy var chooseAdditionalItemView = UIView()

    private lazy var chooseAdditionalItemLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.text = L10n.MenuDetail.additionalItemLabel
        view.textColor = .systemGray
        view.font = .systemFont(ofSize: 12)
        return view
    }()

    private lazy var additionalItemLabel: UILabel = {
        let view = UILabel()
        view.text = "Cola 0.5"
        view.font = .systemFont(ofSize: 16, weight: .medium)
        return view
    }()

    private lazy var chooseAdditionalItemButton: UIButton = {
        let view = UIButton()
        view.setTitle(L10n.MenuDetail.chooseAdditionalItemButton, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.setTitleColor(.kexRed, for: .normal)
        view.addTarget(self, action: #selector(additionalItemChangeButtonTapped), for: .touchUpInside)
        return view
    }()

    private lazy var commentaryField: UITextField = {
        let view = UITextField()
        view.attributedPlaceholder = NSAttributedString(
            string: L10n.MenuDetail.commentaryField,
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        view.isEnabled = false
        return view
    }()

    private lazy var proceedButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .kexRed
        view.setTitle("В корзину за 1 490 ₸", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let dimmedView = UIView()

    private var commentaryPage: MapCommentaryPage?

    public init(viewModel: MenuDetailViewModelProtocol) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { nil }

    override public func viewDidLoad() {
        super.viewDidLoad()
//        bind()
        layoutUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.shadowImage = .init()
        navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .kexRed
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron.left"), style: .plain, target: self, action: #selector(dismissVC))
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        viewModel.coordinator.didFinish()
    }

//    private func bind() {
//        viewModel.itemTitle
//            .bind(to: itemTitleLabel.rx.text)
//            .disposed(by: disposeBag)
//        viewModel.itemDescription
//            .bind(to: descriptionLabel.rx.text)
//            .disposed(by: disposeBag)
//        viewModel.itemPrice
//            .bind(to: proceedButton.rx.title())
//            .disposed(by: disposeBag)
//    }
}

extension MenuDetailController {
    private func layoutUI() {
        view.backgroundColor = .white
        tabBarController?.tabBar.backgroundColor = .white

        [chooseAdditionalItemLabel, additionalItemLabel, chooseAdditionalItemButton].forEach { chooseAdditionalItemView.addSubview($0) }
        commentaryView.addSubview(commentaryField)
        [imageView, itemTitleLabel, descriptionLabel, chooseAdditionalItemView, commentaryView, proceedButton, dimmedView].forEach { view.addSubview($0) }

        imageView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(43)
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.height.equalToSuperview().multipliedBy(0.33)
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
            $0.top.equalTo(chooseAdditionalItemView.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }

        commentaryView.snp.makeConstraints {
            $0.top.equalTo(chooseAdditionalItemView.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(50)
        }

        proceedButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.height.equalTo(43)
        }

        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        dimmedView.backgroundColor = .gray
        dimmedView.alpha = 0
    }
}

extension MenuDetailController {
    @objc private func additionalItemChangeButtonTapped() {
        viewModel.coordinator.openModificator()
    }

    @objc private func commetaryViewTapped(_: UITapGestureRecognizer? = nil) {
        commentaryPage = MapCommentaryPage()
        guard let page = commentaryPage else { return }
        page.cachedCommentary = commentaryField.text
        page.delegate = self
        present(page, animated: true, completion: nil)
        dimmedView.alpha = 0.5
    }

    @objc private func keyboardWillHide() {
        dimmedView.alpha = 0
    }

    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}

extension MenuDetailController: MapCommentaryPageDelegate {
    func onDoneButtonTapped(commentary: String) {
        commentaryField.text = commentary
    }
}
