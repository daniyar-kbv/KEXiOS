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

    func getCart()
    func getTotalPrice() -> String
    func getIsEmpty() -> Bool
    func applyPromocode(promocode: String?)

    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func headerView(for section: Int) -> UIView
    func cell(for indexPath: IndexPath) -> UITableViewCell
    func footerView(for section: Int) -> UIView

    func proceedButtonTapped()
}

final class CartViewModelImpl: CartViewModel {
    private let disposeBag = DisposeBag()
    private let cartRepository: CartRepository
    private let tokenStorage: AuthTokenStorage

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
    func getCart() {
        cartRepository.getItems()
    }

    func getTotalPrice() -> String {
        return (getCartItemsPrice() + getAdditionalItemsPrice()).removeTrailingZeros()
    }

    func getIsEmpty() -> Bool {
        return cartItems.isEmpty
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
                count: getCartItemsCount() + getAdditionalItemsCount(),
                sum: getCartItemsPrice() + getAdditionalItemsPrice()
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
        }
    }

    func footerView(for section: Int) -> UIView {
        guard section == tableSections.count - 1 else {
            let view = UIView()
            view.snp.makeConstraints {
                $0.height.equalTo(0)
            }
            return view
        }
        let viewModel = CartFooterViewModelImpl(input: .init(
            count: getCartItemsCount() + getAdditionalItemsCount(),
            productsPrice: getCartItemsPrice() + getAdditionalItemsPrice(),
            delivaryPrice: 500
        ))
        return CartFooter(viewModel: viewModel)
    }
}

extension CartViewModelImpl {
    private func bindCartRepository() {
        cartRepository.outputs.didChange
            .subscribe(onNext: { [weak self] items in
                self?.process(cartItems: items.positions, additionalItems: items.additional)
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

    private func process(cartItems: [CartItem], additionalItems: [CartItem]) {
        self.cartItems = cartItems
        self.additionalItems = additionalItems

        tableSections = []
        tableSections.append(.init(
            headerViewModel: CartHeaderViewModelImpl(type: .positions(
                count: cartItems.count,
                sum: cartItems.map { ($0.position.price ?? 0) * Double($0.count) }.reduce(0, +)
            )),
            cellViewModels: cartItems.map { CartProductViewModelImpl(inputs: .init(item: $0)) },
            type: .products
        ))

        if !additionalItems.isEmpty {
            tableSections.append(.init(
                headerViewModel: CartHeaderViewModelImpl(type: .additional),
                cellViewModels: additionalItems.map { CartAdditionalProductViewModelImpl(inputs: .init(item: $0)) },
                type: .additional
            ))
        }

        tableSections.append(.init(
            headerViewModel: nil,
            cellViewModels: [CartPromocodeViewModelImpl(promocode: promocode)],
            type: .promocode
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

    private func getCartItemsCount() -> Int {
        return cartItems.map { $0.count }.reduce(0, +)
    }

    private func getAdditionalItemsCount() -> Int {
        return additionalItems.map { $0.count }.reduce(0, +)
    }

    private func getCartItemsPrice() -> Double {
        return cartItems.map { ($0.position.price ?? 0) * Double($0.count) }.reduce(0, +)
    }

    private func getAdditionalItemsPrice() -> Double {
        return additionalItems.map { ($0.position.price ?? 0) * Double($0.count) }.reduce(0, +)
    }
}

extension CartViewModelImpl: CartAdditinalProductCellDelegate {
    func increment(positionUUID: String?, isAdditional _: Bool) {
        guard let positionUUID = positionUUID else { return }
        cartRepository.incrementItem(positionUUID: positionUUID)
    }

    func decrement(positionUUID: String?, isAdditional _: Bool) {
        guard let positionUUID = positionUUID else { return }
        cartRepository.decrementItem(positionUUID: positionUUID)
    }

    func delete(positionUUID: String?, isAdditional _: Bool) {
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
