//
//  CartController.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import RxCocoa
import RxSwift
import UIKit

protocol CartViewDelegate {
    func proceed()
}

// FIXME: Refactor
class CartController: UIViewController, LoaderDisplayable, Reloadable {
    private let viewModel: CartViewModel
    private let disposeBag = DisposeBag()

    let outputs = Output()

    private lazy var itemsTableView: UITableView = {
        let table = UITableView()
        table.allowsSelection = false
        table.dataSource = self
        table.delegate = self
        table.estimatedSectionHeaderHeight = UITableView.automaticDimension
        table.estimatedSectionFooterHeight = UITableView.automaticDimension
        table.separatorStyle = .none
        table.refreshControl = refreshControl
        return table
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(reload), for: .valueChanged)
        return view
    }()

    private lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .mildBlue
        return view
    }()

    private lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var orderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .kexRed
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()

    private let dimmedView = UIView()

    init(viewModel: CartViewModel) {
        self.viewModel = viewModel

        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = SBLocalization.localized(key: CartText.Cart.navigationTitle)

        layoutUI()
        bindViewModel()

        viewModel.getCart()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reload()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        configAnimationView()
    }
}

extension CartController {
    @objc func reload() {
        viewModel.reload()
    }

    @objc func buttonAction() {
        viewModel.proceedButtonTapped()
    }

    func openPromocode() {
        let commentaryPage = MapCommentaryPage()

        commentaryPage.configureTextField(placeholder: SBLocalization.localized(key: CartText.Cart.Promocode.placeholder))
        commentaryPage.configureButton(title: SBLocalization.localized(key: CartText.Cart.Promocode.button))
        commentaryPage.configureTextField(autocapitalizationType: .allCharacters)

        commentaryPage.output.didProceed
            .subscribe(onNext: { [weak self] promocode in
                self?.viewModel.applyPromocode(promocode: promocode)
            }).disposed(by: disposeBag)

        commentaryPage.openTransitionSheet(on: self)
    }
}

extension CartController {
    private func layoutUI() {
        view.backgroundColor = .arcticWhite

        [divider, orderButton].forEach {
            footerView.addSubview($0)
        }
        [itemsTableView, footerView].forEach {
            view.addSubview($0)
        }

        divider.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(footerView.snp.width)
        }

        orderButton.snp.makeConstraints {
            $0.left.equalTo(footerView.snp.left).offset(24)
            $0.right.equalTo(footerView.snp.right).offset(-24)
            $0.centerY.equalTo(footerView.snp.centerY)
            $0.height.equalTo(43)
        }

        footerView.snp.makeConstraints {
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(75)
        }

        itemsTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            $0.bottom.equalTo(footerView.snp.top)
        }
    }

    private func bindViewModel() {
        viewModel.outputs.update
            .subscribe(onNext: { [weak self] in
                self?.update()
            }).disposed(by: disposeBag)

        viewModel.outputs.didStartRequest
            .subscribe(onNext: { [weak self] in
                self?.showLoader()
            }).disposed(by: disposeBag)

        viewModel.outputs.didEndRequest
            .subscribe(onNext: { [weak self] in
                self?.hideLoader()
            }).disposed(by: disposeBag)

        viewModel.outputs.didGetError
            .subscribe(onNext: { [weak self] error in
                self?.showError(error)
            }).disposed(by: disposeBag)

        viewModel.outputs.toAuth
            .bind(to: outputs.toAuth)
            .disposed(by: disposeBag)

        viewModel.outputs.toPayment
            .bind(to: outputs.toPayment)
            .disposed(by: disposeBag)

        viewModel.outputs.showPromocode
            .subscribe(onNext: { [weak self] in
                self?.openPromocode()
            })
            .disposed(by: disposeBag)
    }

    private func update() {
        configAnimationView()
        itemsTableView.reloadData()
        orderButton.setTitle(SBLocalization.localized(key: CartText.Cart.buttonTitle, arguments: viewModel.getTotalPrice()), for: .normal)
    }

    private func configAnimationView() {
        guard viewModel.getIsEmpty() else {
            hideAnimationView(completionHandler: nil)
            return
        }

        showAnimationView(animationType: .emptyBasket) { [weak self] in
            self?.outputs.toMenu.accept(())
        }
    }
}

extension CartController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        viewModel.headerView(for: section)
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(for: indexPath)
    }

    func tableView(_: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewModel.footerView(for: section)
    }

    func tableView(_: UITableView, estimatedHeightForHeaderInSection _: Int) -> CGFloat {
        return 56
    }

    func tableView(_: UITableView, estimatedHeightForFooterInSection _: Int) -> CGFloat {
        return 56
    }
}

extension CartController {
    struct Output {
        let toAuth = PublishRelay<Void>()
        let toPayment = PublishRelay<Void>()
        let toMenu = PublishRelay<Void>()
    }
}
