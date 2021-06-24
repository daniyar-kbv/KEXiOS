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
class CartController: UIViewController {
    private let viewModel: CartViewModel
    private let disposeBag = DisposeBag()

    let outputs = Output()
    private var mainTabDelegate: MainTabDelegate?

    private var commentaryPage: MapCommentaryPage?

    // private lazy var emptyCartView = AnimationContainerView(delegate: self, animationType: .emptyBasket)

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
        layoutUI()
        bindViewModel()
        viewModel.getCart()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.shadowImage = .init()
        navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .kexRed
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: UIColor.black,
        ]
        navigationItem.title = L10n.Cart.title
    }

    private func bindViewModel() {
        viewModel.outputs.update
            .subscribe(onNext: { [weak self] in
                self?.update()
            }).disposed(by: disposeBag)
    }

    private func update() {
        itemsTableView.reloadData()
        updateTableViewFooterUI()
        orderButton.setTitle(L10n.Cart.OrderButton.title(viewModel.getTotalPrice()), for: .normal)
    }
}

extension CartController {
    private func layoutUI() {
        view.backgroundColor = .arcticWhite

        [divider, orderButton].forEach {
            footerView.addSubview($0)
        }
        [itemsTableView, footerView, dimmedView].forEach {
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

        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        dimmedView.backgroundColor = .gray
        dimmedView.alpha = 0
    }

    func updateTableViewFooterUI() {
        tableViewFooter.productsLabel.text = L10n.CartFooter.productsCount(viewModel.getTotalCount())
        tableViewFooter.productsPriceLabel.text = L10n.CartFooter.productsPrice(viewModel.getTotalPrice())
    }

    @objc func buttonAction() {
        outputs.toAuth.accept(())
    }
}

// MARK: - UITableView

extension CartController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 56
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let content = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 56))
            let label = UILabel(frame: CGRect(x: 16, y: 24, width: tableView.frame.size.width, height: 24))
            label.font = .boldSystemFont(ofSize: 18)
            label.text = L10n.Cart.Section0.title(viewModel.getTotalCount(), viewModel.getTotalPrice())
            content.addSubview(label)
            content.backgroundColor = .arcticWhite
            return content
        } else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 56))
            let label = UILabel(frame: CGRect(x: 16, y: 24, width: tableView.frame.size.width, height: 21))
            let separator = UIView(frame: CGRect(x: 24, y: 0, width: tableView.frame.width - 48, height: 0.5))
            separator.backgroundColor = .mildBlue
            label.font = .boldSystemFont(ofSize: 16)
            label.text = L10n.Cart.Section1.title
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

// MARK: - Cell Actions

extension CartController: CartAdditinalProductCellDelegate {
    func increment(positionUUID: String?, isAdditional _: Bool) {
        guard let positionUUID = positionUUID else { return }
        viewModel.increment(postitonUUID: positionUUID)
    }

    func decrement(positionUUID: String?, isAdditional _: Bool) {
        guard let positionUUID = positionUUID else { return }
        viewModel.decrement(postitonUUID: positionUUID)
    }

    func delete(positionUUID _: String?, isAdditional _: Bool) {
//        TODO: finish
    }
}

// extension CartController: AnimationContainerViewDelegate {
//    func performAction() {}
// }

extension CartController: CartFooterDelegate {
    func openPromocode() {
        commentaryPage = MapCommentaryPage()
        guard let page = commentaryPage else { return }
        page.delegate = self
        page.configureTextField(placeholder: L10n.Promocode.field)
        page.configureButton(title: L10n.Promocode.button)
        present(page, animated: true, completion: nil)
        dimmedView.alpha = 0.5
    }

    @objc private func keyboardWillHide() {
        dimmedView.alpha = 0
    }
}

extension CartController: MapCommentaryPageDelegate {
    func onDoneButtonTapped(commentary _: String) {}
}

extension CartController {
    struct Output {
        let toAuth = PublishRelay<Void>()
    }
}
