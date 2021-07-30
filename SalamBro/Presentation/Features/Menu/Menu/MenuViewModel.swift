//
//  MenuViewModel.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation
import RxCocoa
import RxSwift
import SVProgressHUD

protocol MenuViewModelProtocol {
    var outputs: MenuViewModel.Output { get }

    func update()
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func heightForHeader(in section: Int) -> CGFloat
    func viewForHeader(in tableView: UITableView, for section: Int) -> UIView?
    func cell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
    func didSelectRow(at indexPath: IndexPath)
    func finishedScrolling()
    func willDisplayRow(at indexPath: IndexPath)
}

final class MenuViewModel: MenuViewModelProtocol {
    private let disposeBag = DisposeBag()
    let outputs = Output()

    private let locationRepository: AddressRepository
    private let brandRepository: BrandRepository
    private let menuRepository: MenuRepository
    private let defaultStorage: DefaultStorage

    private var tableSections: [Section] = []
    private var scrollService: MenuScrollService

    init(locationRepository: AddressRepository,
         brandRepository: BrandRepository,
         menuRepository: MenuRepository,
         defaultStorage: DefaultStorage,
         scrollService: MenuScrollService)
    {
        self.locationRepository = locationRepository
        self.brandRepository = brandRepository
        self.menuRepository = menuRepository
        self.defaultStorage = defaultStorage
        self.scrollService = scrollService

        bindMenuRepository()
        bindAddressRepository()
        bindScrollService()
    }

    private func bindMenuRepository() {
        menuRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        menuRepository.outputs.didEndRequest.bind {
            [weak self] _ in
            self?.outputs.didEndRequest.accept(())
            self?.outputs.updateTableView.accept(())
        }
        .disposed(by: disposeBag)

        menuRepository.outputs.didGetError
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)

        menuRepository.outputs.didGetPromotions.bind {
            [weak self] promotions in
            self?.setPromotions(promotions: promotions)
        }
        .disposed(by: disposeBag)

        menuRepository.outputs.didGetCategories.bind {
            [weak self] categories in
            self?.setCategories(categories: categories)
        }
        .disposed(by: disposeBag)

        menuRepository.outputs.didGetPositions.bind {
            [weak self] positions in
            self?.setPositions(positions: positions)
        }
        .disposed(by: disposeBag)
    }

    private func bindAddressRepository() {
        locationRepository.outputs.didGetLeadUUID
            .subscribe(onNext: { [weak self] in
                self?.update()
            }).disposed(by: disposeBag)
    }

    private func bindScrollService() {
        scrollService.didSelectCategory
            .subscribe(onNext: { [weak self] source, category in
                guard source == .header else { return }
                self?.scroll(to: category)
            })
            .disposed(by: disposeBag)
    }

    private func download() {
        tableSections.removeAll()

        menuRepository.getMenuItems()
    }

    private func setPromotions(promotions: [Promotion]) {
        let promotions = promotions.sorted(by: { $0.priority < $1.priority })

        let addressViewModels = [AddressPickCellViewModel(address: locationRepository.getCurrentDeliveryAddress()?.address)]
        tableSections.append(.init(type: .address,
                                   headerViewModel: nil,
                                   cellViewModels: addressViewModels))

        if promotions.count > 0 {
            let promotionsViewModels = [AdCollectionCellViewModel(promotions: promotions)]
            tableSections.append(.init(type: .promotions,
                                       headerViewModel: nil,
                                       cellViewModels: promotionsViewModels))
        }
    }

    private func setCategories(categories: [MenuCategory]) {
        tableSections.append(.init(
            type: .positions,
            headerViewModel: CategoriesSectionHeaderViewModel(categories: categories),
            cellViewModels: []
        )
        )
    }

    private func setPositions(positions: [MenuPosition]) {
        tableSections
            .first(where: { $0.type == .positions })?
            .cellViewModels = positions.map { position in
                MenuCellViewModel(position: position)
            }
    }
}

extension MenuViewModel {
    func update() {
        download()

        outputs.brandImage.accept(brandRepository.getCurrentBrand()?.image)
        outputs.brandName.accept(brandRepository.getCurrentBrand()?.name)
    }

    func numberOfSections() -> Int {
        return tableSections.count
    }

    func numberOfRows(in section: Int) -> Int {
        return tableSections[section].cellViewModels.count
    }

    func heightForHeader(in section: Int) -> CGFloat {
        guard isNotEmpty(at: section) else { return 0 }
        switch tableSections[section].type {
        case .positions:
            return 44
        default:
            return 0
        }
    }

    func viewForHeader(in tableView: UITableView, for section: Int) -> UIView? {
        guard isNotEmpty(at: section) else { return nil }
        switch tableSections[section].type {
        case .positions:
            guard let headerViewModel = tableSections[section].headerViewModel as? CategoriesSectionHeaderViewModelProtocol
            else { return nil }
            let header = tableView.dequeueReusableHeaderFooterView(CategoriesSectionHeader.self)
            header?.set(headerViewModel)
            header?.scrollService = scrollService
            return header
        default:
            return nil
        }
    }

    func cell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard isNotEmpty(at: indexPath.section) else { return .init() }
        let cellViewModel = tableSections[indexPath.section].cellViewModels[indexPath.row]
        switch tableSections[indexPath.section].type {
        case .address:
            guard let viewModel = cellViewModel as? AddressPickCellViewModelProtocol
            else { return .init() }
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: AddressPickCell.self)
            cell.set(viewModel)
            return cell
        case .promotions:
            guard let viewModel = cellViewModel as? AdCollectionCellViewModelProtocol
            else { return .init() }
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: AdCollectionCell.self)
            cell.set(viewModel)
            cell.delegate = self
            return cell
        case .positions:
            guard let viewModel = cellViewModel as? MenuCellViewModelProtocol
            else { return .init() }
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MenuCell.self)
            cell.set(viewModel)
            return cell
        }
    }

    func didSelectRow(at indexPath: IndexPath) {
        guard isNotEmpty(at: indexPath.section) else { return }
        switch tableSections[indexPath.section].type {
        case .positions:
            guard let cellViewModel = tableSections[indexPath.section]
                .cellViewModels[indexPath.row]
                as? MenuCellViewModelProtocol
            else { return }
            outputs.toPositionDetail.accept(cellViewModel.position.uuid)
        case .address:
            outputs.toAddressess.accept { [weak self] in
                self?.update()
            }
        default:
            break
        }
    }

    func willDisplayRow(at indexPath: IndexPath) {
        didScrollToItem(at: indexPath.row)
    }

    func finishedScrolling() {
        scrollService.finishedScrolling()
    }
}

extension MenuViewModel: AddCollectionCellDelegate {
    private func scroll(to categoryUUID: String) {
        guard isNotEmpty(),
              let positionsIndex = getSectionIndex(of: .positions),
              let row = tableSections[positionsIndex]
              .cellViewModels
              .firstIndex(where: {
                  guard let viewModel = $0 as? MenuCellViewModelProtocol else { return false }
                  return viewModel.position.categoryUUID == categoryUUID
              })
        else { return }

        let indexPath = IndexPath(row: row, section: numberOfSections() - 1)
        outputs.scrollToRowAt.accept(indexPath)
    }

    private func didScrollToItem(at position: Int) {
        guard isNotEmpty(),
              let positionsIndex = getSectionIndex(of: .positions),
              let cellViewModel = tableSections[positionsIndex]
              .cellViewModels[position]
              as? MenuCellViewModelProtocol,
              !scrollService.isHeaderScrolling,
              scrollService.currentCategory != cellViewModel.position.categoryUUID else { return }

        scrollService.didSelectCategory.accept((source: .table, categoryUUID: cellViewModel.position.categoryUUID))
    }

    private func isNotEmpty(at section: Int? = nil) -> Bool {
        guard let section = section else {
            return numberOfSections() > 0
        }

        return numberOfSections() > 0 && numberOfRows(in: section) > 0
    }

    private func getSectionIndex(of type: Section.`Type`) -> Int? {
        return tableSections.firstIndex(where: { $0.type == type })
    }

    public func goToRating(promotionURL: URL, name: String) {
        outputs.toPromotion.accept((promotionURL, name))
    }
}

extension MenuViewModel {
    struct Output {
        let brandImage = PublishRelay<String?>()
        let brandName = PublishRelay<String?>()

        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let updateTableView = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable?>()

        let toPromotion = PublishRelay<(URL, String)>()
        let toAddressess = PublishRelay<() -> Void>()
        let toPositionDetail = PublishRelay<String>()

        let scrollToRowAt = PublishRelay<IndexPath>()
    }

    class Section {
        let type: Type
        let headerViewModel: ViewModel?
        var cellViewModels: [ViewModel]

        init(type: Type, headerViewModel: ViewModel?, cellViewModels: [ViewModel]) {
            self.type = type
            self.headerViewModel = headerViewModel
            self.cellViewModels = cellViewModels
        }

        enum `Type` {
            case address
            case promotions
            case positions
        }
    }
}
