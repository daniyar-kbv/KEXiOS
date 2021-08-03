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
class CartController: UIViewController, LoaderDisplayable, AlertDisplayable {
    private let viewModel: CartViewModel
    private let disposeBag = DisposeBag()

    let outputs = Output()

    private lazy var tableViewFooter: CartFooter = {
        let view = CartFooter()
        view.delegate = self
        return view
    }()

    private lazy var itemsTableView: UITableView = {
        let table = UITableView()
        table.allowsSelection = false
        table.separatorColor = .mildBlue
        table.register(cellType: CartProductCell.self)
        table.register(cellType: CartAdditionalProductCell.self)
        table.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        table.dataSource = self
        table.delegate = self
        // hidden header fix, usually default headers of section in tableview is sticky
        let dummyViewHeight = CGFloat(56)
        table.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: table.bounds.size.width, height: dummyViewHeight))
        table.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        tableViewFooter.frame = CGRect(x: 0, y: 0, width: table.frame.width, height: 160)
        table.tableFooterView = tableViewFooter
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .mildBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var orderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .kexRed
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        configAnimationView()
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
    }

    private func update() {
        configAnimationView()
        itemsTableView.reloadData()
        updateTableViewFooterUI()
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

    func updateTableViewFooterUI() {
        tableViewFooter.productsLabel.text = SBLocalization.localized(key: CartText.Cart.Footer.productsCount, arguments: String(viewModel.getTotalCount()))
        tableViewFooter.productsPriceLabel.text = SBLocalization.localized(key: CartText.Cart.Footer.productsPrice, arguments: String(viewModel.getTotalPrice()))
    }

    @objc func buttonAction() {
        viewModel.proceedButtonTapped()
    }
}

extension CartController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 56
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let content = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 56))
            let label = UILabel(frame: CGRect(x: 16, y: 24, width: tableView.frame.size.width, height: 24))
            label.font = .boldSystemFont(ofSize: 18)
            label.text = SBLocalization.localized(key: CartText.Cart.titleFirst, arguments: String(viewModel.getTotalCount()), String(viewModel.getTotalPrice()))
            content.addSubview(label)
            content.backgroundColor = .arcticWhite
            return content
        } else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 56))
            let label = UILabel(frame: CGRect(x: 16, y: 24, width: tableView.frame.size.width, height: 21))
            let separator = UIView(frame: CGRect(x: 24, y: 0, width: tableView.frame.width - 48, height: 0.5))
            separator.backgroundColor = .mildBlue
            label.font = .boldSystemFont(ofSize: 16)
            label.text = SBLocalization.localized(key: CartText.Cart.titleSecond)
            view.addSubview(label)
            view.addSubview(separator)
            view.backgroundColor = .arcticWhite
            return view
        }
    }

    func numberOfSections(in _: UITableView) -> Int {
//        Tech debt: change to 2 when modifiers stabilize
        1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
//        Tech debt: uncomment when modifiers stabilize
//        if section == 0 {
        return viewModel.getTotalCount()
//        }
//        else {
//            return cartViewModel.cart.productsAdditional.count
//        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        Tech debt: uncomment when modifiers stabilize
        //      if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CartProductCell.self)
        cell.delegate = self
        cell.configure(with: viewModel.items[indexPath.row])
        return cell
        //    } else {
        //      let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CartAdditionalProductCell.self)
        //  cell.delegate = self
        // cell.configure(item: cartViewModel.cart.productsAdditional[indexPath.row])
        //   cell.configureIncreaseButton()
        //     return cell
        // }
    }
}

extension CartController: CartAdditinalProductCellDelegate {
    func increment(positionUUID: String?, isAdditional _: Bool) {
        guard let positionUUID = positionUUID else { return }
        viewModel.increment(postitonUUID: positionUUID)
    }

    func decrement(positionUUID: String?, isAdditional _: Bool) {
        guard let positionUUID = positionUUID else { return }
        viewModel.decrement(postitonUUID: positionUUID)
    }

    func delete(positionUUID: String?, isAdditional _: Bool) {
        guard let positionUUID = positionUUID else { return }
        viewModel.delete(postitonUUID: positionUUID)
    }
}

extension CartController: CartFooterDelegate {
    func openPromocode() {
        let commentaryPage = MapCommentaryPage()

        commentaryPage.configureTextField(placeholder: SBLocalization.localized(key: CartText.Cart.Promocode.placeholder))
        commentaryPage.configureButton(title: SBLocalization.localized(key: CartText.Cart.Promocode.button))

        commentaryPage.output.didProceed.subscribe(onNext: { _ in

        }).disposed(by: disposeBag)

        commentaryPage.openTransitionSheet(on: self)
    }
}

extension CartController {
    struct Output {
        let toAuth = PublishRelay<Void>()
        let toPayment = PublishRelay<Void>()
        let toMenu = PublishRelay<Void>()
    }
}
