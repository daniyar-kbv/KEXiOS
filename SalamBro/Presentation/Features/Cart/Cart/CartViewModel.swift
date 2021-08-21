//
//  CartViewModel.swift
//  SalamBro
//
//  Created by Arystan on 4/23/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol CartViewModel {
    var outputs: CartViewModelImpl.Output { get }

    func reload()
    func getCart()
    func getTotalPrice() -> String
    func getIsEmpty() -> Bool
    func additionalsEmpty() -> Bool
    func applyPromocode(promocode: String?)

    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func headerView(for section: Int) -> UIView
    func cell(for indexPath: IndexPath) -> UITableViewCell

    func proceedButtonTapped()
}

final class CartViewModelImpl: CartViewModel {
    private let disposeBag = DisposeBag()
    private let cartRepository: CartRepository
    private let tokenStorage: AuthTokenStorage

    private var cart: Cart = .init(items: [], price: 0, positionsCount: 0)
    private var cartItems: [CartItem] = []
    private var additionalItems: [CartItem] = []
    private var tableSections: [TableSection] = []
    private var promocode: Promocode?
    let outputs = Output()

    init(cartRepository: CartRepository,
         tokenStorage: AuthTokenStorage)
    {
        self.cartRepository = cartRepository
        self.tokenStorage = tokenStorage

        bindCartRepository()
    }
}

extension CartViewModelImpl {
    func reload() {
        cartRepository.reload()
    }

    func getCart() {
        cartRepository.getItems(withLoader: true)
    }

    func getTotalPrice() -> String {
        return cart.price.formattedWithSeparator
    }

    func getIsEmpty() -> Bool {
        return cart.items.isEmpty
    }

    func additionalsEmpty() -> Bool {
        return additionalItems.isEmpty
    }

    func proceedButtonTapped() {
        guard tokenStorage.token != nil else {
            outputs.toAuth.accept(())
            return
        }

        outputs.toPayment.accept(())
    }

    func applyPromocode(promocode: String?) {
        guard let promocode = promocode,
              !promocode.isEmpty else { return }
        cartRepository.applyPromocode(promocode)
    }
}

extension CartViewModelImpl {
    func numberOfSections() -> Int {
        return tableSections.count
    }

    func numberOfRows(in section: Int) -> Int {
        return tableSections[section].cellViewModels.count
    }

    func headerView(for section: Int) -> UIView {
        switch tableSections[section].type {
        case .products:
            let viewModel = CartHeaderViewModelImpl(type: .positions(
                count: cart.positionsCount,
                sum: cart.price
            ))
            return CartHeader(viewModel: viewModel)
        case .additional:
            let viewModel = CartHeaderViewModelImpl(type: .additional)
            return CartHeader(viewModel: viewModel)
        case .promocode:
            guard let promocode = promocode else {
                let view = UIView()
                view.snp.makeConstraints {
                    $0.height.equalTo(0)
                }
                return view
            }
            let viewModel = CartHeaderViewModelImpl(type: .promocode(promocode: promocode.promocode))
            return CartHeader(viewModel: viewModel)
        case .footer:
            let view = UIView()
            view.snp.makeConstraints {
                $0.height.equalTo(0)
            }
            return view
        }
    }

    func cell(for indexPath: IndexPath) -> UITableViewCell {
        let tableSection = tableSections[indexPath.section]
        let viewModel = tableSection.cellViewModels[indexPath.row]
        switch tableSection.type {
        case .products:
            guard let viewModel = viewModel as? CartProductViewModel
            else { return UITableViewCell() }
            let cell = CartProductCell(viewModel: viewModel)
            cell.delegate = self
            return cell
        case .additional:
            guard let viewModel = viewModel as? CartAdditionalProductViewModel
            else { return UITableViewCell() }
            let cell = CartAdditionalProductCell(viewModel: viewModel)
            cell.delegate = self
            return cell
        case .promocode:
            guard let viewModel = viewModel as? CartPromocodeViewModel
            else { return UITableViewCell() }
            let cell = CartPromocodeCell(viewModel: viewModel)
            cell.delegate = self
            return cell
        case .footer:
            guard let viewModel = viewModel as? CartFooterViewModel
            else { return UITableViewCell() }
            let cell = CartFooterCell(viewModel: viewModel)
            return cell
        }
    }
}

extension CartViewModelImpl {
    private func bindCartRepository() {
        cartRepository.outputs.didChange
            .subscribe(onNext: { [weak self] cartInfo, additionalItems in
                self?.process(cart: cartInfo, additionalItems: additionalItems)
                self?.outputs.update.accept(())
            }).disposed(by: disposeBag)

        cartRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        cartRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        cartRepository.outputs.didGetError
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)

        cartRepository.outputs.promocode
            .subscribe(onNext: { [weak self] promocode in
                self?.process(promocode: promocode)
            })
            .disposed(by: disposeBag)
    }

    private func process() {
        cartItems = []
        cart.items.forEach { item in
            if item.position.isAdditional {
                if let ind = additionalItems.firstIndex(where: { $0.position.uuid == item.position.uuid }) {
                    additionalItems[ind].count = item.count
                }
            } else {
                cartItems.append(item)
            }
        }

        let additionals = cart.items.filter { $0.position.isAdditional }
        if additionals.isEmpty {
            for i in 0 ..< additionalItems.count {
                additionalItems[i].count = 0
            }
        }
    }

    private func process(cart: Cart, additionalItems: [CartItem]) {
        self.cart = cart
        self.additionalItems = additionalItems

        process()

        tableSections = []
        tableSections.append(.init(
            headerViewModel: CartHeaderViewModelImpl(type: .positions(
                count: cartItems.count,
                sum: cart.price
            )),
            cellViewModels: cartItems.map { CartProductViewModelImpl(inputs: .init(item: $0)) },
            type: .products
        ))

        if !self.additionalItems.isEmpty {
            tableSections.append(.init(
                headerViewModel: CartHeaderViewModelImpl(type: .additional),
                cellViewModels: self.additionalItems.map { CartAdditionalProductViewModelImpl(inputs: .init(item: $0), cartRepository: cartRepository) },
                type: .additional
            ))
        }

        tableSections.append(.init(
            headerViewModel: nil,
            cellViewModels: [CartPromocodeViewModelImpl(promocode: promocode)],
            type: .promocode
        ))

        let footerViewModel = CartFooterViewModelImpl(input: .init(
            count: cart.positionsCount,
            productsPrice: cart.price,
            delivaryPrice: 500
        ))

        tableSections.append(.init(
            headerViewModel: nil,
            cellViewModels: [footerViewModel],
            type: .footer
        ))

        outputs.update.accept(())
    }

    private func process(promocode: Promocode) {
        self.promocode = promocode
        if let index = tableSections.firstIndex(where: { $0.type == .promocode }),
           let viewModel = tableSections[index].cellViewModels.first as? CartPromocodeViewModelImpl
        {
            viewModel.set(state: .set(description: promocode.description))
        }
        outputs.update.accept(())
    }
}

extension CartViewModelImpl: CartAdditinalProductCellDelegate {
    func increment(positionUUID: String?) {
        guard let positionUUID = positionUUID else { return }
        cartRepository.incrementItem(positionUUID: positionUUID)
    }

    func decrement(positionUUID: String?) {
        guard let positionUUID = positionUUID else { return }
        cartRepository.decrementItem(positionUUID: positionUUID)
    }

    func delete(positionUUID: String?) {
        guard let positionUUID = positionUUID else { return }
        cartRepository.removeItem(positionUUID: positionUUID)
    }
}

extension CartViewModelImpl: CartPromocodeCellDelegate {
    func promocodeTapped() {
        outputs.showPromocode.accept(())
    }
}

extension CartViewModelImpl {
    struct TableSection {
        let headerViewModel: CartHeaderViewModel?
        let cellViewModels: [CartCellViewModel]
        let type: SectionType

        enum SectionType {
            case products
            case additional
            case promocode
            case footer
        }
    }

    struct Output {
        let update = PublishRelay<Void>()
        let showPromocode = PublishRelay<Void>()

        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()

        let toAuth = PublishRelay<Void>()
        let toPayment = PublishRelay<Void>()
    }
}
