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
class CartController: ViewController {
    private let viewModel: CartViewModel
    private let disposeBag = DisposeBag()

    let outputs = Output()

    // private lazy var emptyCartView = AnimationContainerView(delegate: self, animationType: .emptyBasket)

    lazy var commentarySheetVC = CommentarySheetController()

    lazy var tableViewFooter: CartFooter = {
        let view = CartFooter()
        view.delegate = self
        return view
    }()

    lazy var itemsTableView: UITableView = {
        let table = UITableView()
        table.allowsSelection = false
        table.separatorColor = .mildBlue
        table.register(UINib(nibName: "CartProductCell", bundle: nil), forCellReuseIdentifier: "CartProductCell")
        table.register(UINib(nibName: "CartAdditionalProductCell", bundle: nil), forCellReuseIdentifier: "CartAdditionalProductCell")
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

    lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .mildBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var orderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .kexRed
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var shadow: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.opacity = 0.7
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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
        setupViews()
        setupConstraints()
        bindViewModel()
        viewModel.getCart()
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
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
    fileprivate func setupViews() {
        view.backgroundColor = .white
        footerView.addSubview(divider)
        footerView.addSubview(orderButton)
        view.addSubview(itemsTableView)
        view.addSubview(footerView)
        view.addSubview(shadow)
    }

    fileprivate func setupConstraints() {
        shadow.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        shadow.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        shadow.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        shadow.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.widthAnchor.constraint(equalTo: footerView.widthAnchor).isActive = true

        orderButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        orderButton.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 24).isActive = true
        orderButton.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -24).isActive = true
        orderButton.heightAnchor.constraint(equalToConstant: 43).isActive = true

        footerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        footerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 75).isActive = true

        itemsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        itemsTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        itemsTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        itemsTableView.bottomAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
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
        //        Tech debt: uncomment when modifiers stabilize
//        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartProductCell", for: indexPath) as! CartProductCell
        cell.delegate = self
        cell.bindData(with: viewModel.items[indexPath.row])
        return cell
//        }
//        else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "CartAdditionalProductCell", for: indexPath) as! CartAdditionalProductCell
//            cell.delegate = self
//            cell.bindData(item: cartViewModel.cart.productsAdditional[indexPath.row])
//            return cell
//        }
    }
}

// MARK: - Cell Actions

extension CartController: CellDelegate {
    func increment(positionUUID: String?, isAdditional _: Bool) {
        guard let positionUUID = positionUUID else { return }
        viewModel.increment(postitonUUID: positionUUID)
    }

    func decrement(positionUUID: String?, isAdditional _: Bool) {
        guard let positionUUID = positionUUID else { return }
        viewModel.decrement(postitonUUID: positionUUID)
    }
}

// extension CartController: AnimationContainerViewDelegate {
//    func performAction() {}
// }

extension CartController: CartFooterDelegate {
    func openPromocode() {
        showCommentarySheet()
    }
}

extension CartController: MapDelegate {
    func dissmissView() {
//        print("x")
    }

    func hideCommentarySheet() {
//        addressSheetVC.view.isHidden = false
    }

    func showCommentarySheet() {
        addChild(commentarySheetVC)
        view.addSubview(commentarySheetVC.view)
        commentarySheetVC.proceedButton.setTitle(L10n.Promocode.button, for: .normal)
        commentarySheetVC.commentaryField.attributedPlaceholder = NSAttributedString(
            string: L10n.Promocode.field,
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        commentarySheetVC.delegate = self
        commentarySheetVC.didMove(toParent: self)
        commentarySheetVC.modalPresentationStyle = .overCurrentContext
        let height: CGFloat = 155.0
        let width = view.frame.width

        getScreenSize(heightOfSheet: height, width: width)
    }

    private func getScreenSize(heightOfSheet: CGFloat, width: CGFloat) {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height

        commentarySheetVC.view.frame = height <= 736 ? CGRect(x: 0, y: view.bounds.height - 79 - heightOfSheet, width: width, height: heightOfSheet) : CGRect(x: 0, y: view.bounds.height - 94 - heightOfSheet, width: width, height: heightOfSheet)
    }

    func passCommentary(text _: String) {
//        addressSheetVC.changeComment(comment: text)
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

extension CartController {
    struct Output {
        let toAuth = PublishRelay<Void>()
    }
}
