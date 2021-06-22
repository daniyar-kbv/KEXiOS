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

    private let contentView = MenuDetailView()

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
        configureViews()
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
    private func configureViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(commetaryViewTapped(_:)))
        contentView.commentaryView.addGestureRecognizer(tap)

        contentView.chooseAdditionalItemButton.addTarget(self, action: #selector(additionalItemChangeButtonTapped), for: .touchUpInside)
    }

    private func layoutUI() {
        view.backgroundColor = .white
        tabBarController?.tabBar.backgroundColor = .white

        [contentView, dimmedView].forEach { view.addSubview($0) }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        page.cachedCommentary = contentView.commentaryField.text
        page.delegate = self
        page.configureTextField(placeholder: L10n.MenuDetail.commentaryField)
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
        contentView.commentaryField.text = commentary
    }
}
