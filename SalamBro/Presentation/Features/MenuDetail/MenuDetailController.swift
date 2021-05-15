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

class MenuDetailController: ViewController {
    private var viewModel: MenuDetailViewModelProtocol
    private let disposeBag: DisposeBag
    lazy var commentarySheetVC = CommentarySheetController()

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
        view.text = "Чизбургер куриный"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.text = "Чизбургер куриный"
        return view
    }()

    lazy var commentaryView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.commetaryViewTapped(_:)))
        view.addGestureRecognizer(tap)

        return view
    }()

    lazy var chooseAdditionalItemView = UIView()

    lazy var chooseAdditionalItemLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.text = L10n.MenuDetail.additionalItemLabel
        view.textColor = .systemGray
        view.font = .systemFont(ofSize: 14)
        return view
    }()

    lazy var additionalItemLabel: UILabel = {
        let view = UILabel()
        view.text = "Cola 0.5"
        view.font = .systemFont(ofSize: 16, weight: .medium)
        return view
    }()

    lazy var chooseAdditionalItemButton: UIButton = {
        let view = UIButton()
        view.setTitle(L10n.MenuDetail.chooseAdditionalItemButton, for: .normal)
        view.setTitleColor(.kexRed, for: .normal)
        view.addTarget(self, action: #selector(additionalItemChangeButtonTapped), for: .touchUpInside)
        return view
    }()

    lazy var commentaryField: UITextField = {
        let view = UITextField()
        view.placeholder = L10n.MenuDetail.commentaryField
        view.isEnabled = false
        return view
    }()

    lazy var proceedButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .kexRed
        view.setTitle("В корзину за 1 490 ₸", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.tintColor = .kexRed
        button.setImage(UIImage(named: "chevron.left"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var shadow: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.opacity = 0.7
        view.isHidden = true
        return view
    }()

    public init(viewModel: MenuDetailViewModelProtocol) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { nil }

    override public func viewDidLoad() {
        super.viewDidLoad()
//        bind()
        setup()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .white
        tabBarController?.tabBar.backgroundColor = .white
        [chooseAdditionalItemLabel, additionalItemLabel, chooseAdditionalItemButton].forEach { chooseAdditionalItemView.addSubview($0) }
        commentaryView.addSubview(commentaryField)
        [imageView, itemTitleLabel, descriptionLabel, chooseAdditionalItemView, commentaryView, proceedButton, backButton, shadow].forEach { view.addSubview($0) }
    }

    func setupConstraints() {
        shadow.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }

        imageView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(46)
            $0.left.equalToSuperview().offset(39)
            $0.right.equalToSuperview().offset(-39)
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
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalTo(view.snp.bottomMargin).offset(-16)
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
        let vc = AdditionalItemChooseController()
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true, completion: nil)
    }

    @objc func commetaryViewTapped(_: UITapGestureRecognizer? = nil) {
        showCommentarySheet()
    }

    @objc func backButtonTapped() {
        print("go back")
        dismiss(animated: true, completion: nil)
    }
}

extension MenuDetailController: MapDelegate {
    func dissmissView() {
//        print("x")
    }

    func hideCommentarySheet() {
//        addressSheetVC.view.isHidden = false
    }

    func showCommentarySheet() {
//        addressSheetVC.view.isHidden = true

        addChild(commentarySheetVC)
        view.addSubview(commentarySheetVC.view)
        commentarySheetVC.commentaryField.placeholder = L10n.MenuDetail.commentaryField
        commentarySheetVC.delegate = self
        commentarySheetVC.didMove(toParent: self)
        commentarySheetVC.modalPresentationStyle = .overCurrentContext

        let height: CGFloat = 149.0
        let width = view.frame.width
        commentarySheetVC.view.frame = CGRect(x: 0, y: view.frame.height - height, width: width, height: height)
        print("view frame height: \(view.frame.height)")
    }

    func passCommentary(text: String) {
        commentaryField.text = text
    }

    func reverseGeocoding(searchQuery _: String, title _: String) {
        print("cartController shoud have mapdelegate...")
    }

    func mapShadow(toggle: Bool) {
        if toggle {
            shadow.isHidden = false
        } else {
            shadow.isHidden = true
        }
    }
}
