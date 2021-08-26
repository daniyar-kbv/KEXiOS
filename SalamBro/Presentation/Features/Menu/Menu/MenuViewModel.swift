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
    func processToBrand()
    func processToAddresses()
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func heightForHeader(in section: Int) -> CGFloat
    func viewForHeader(in tableView: UITableView, for section: Int) -> UIView?
    func cell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
    func didSelectRow(at indexPath: IndexPath)
    func finishedScrolling()
    func willDisplayRow(at indexPath: IndexPath)
    func configureAnimation()
}

final class MenuViewModel: MenuViewModelProtocol {
    private let disposeBag = DisposeBag()
    let outputs = Output()

    private let locationRepository: AddressRepository
    private let brandRepository: BrandRepository
    private let menuRepository: MenuRepository
    private let defaultStorage: DefaultStorage
    private let tokenStorage: AuthTokenStorage

    private var tableSections: [Section] = []
    private var scrollService: MenuScrollService

    private var redirectURL = ""

    init(locationRepository: AddressRepository,
         brandRepository: BrandRepository,
         menuRepository: MenuRepository,
         defaultStorage: DefaultStorage,
         tokenStorage: AuthTokenStorage,
         scrollService: MenuScrollService)
    {
        self.locationRepository = locationRepository
        self.brandRepository = brandRepository
        self.menuRepository = menuRepository
        self.defaultStorage = defaultStorage
        self.tokenStorage = tokenStorage
        self.scrollService = scrollService

        bindMenuRepository()
        bindScrollService()
    }

    private func bindMenuRepository() {
        menuRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        menuRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        menuRepository.outputs.didGetError
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)

        menuRepository.outputs.didGetData
            .subscribe(onNext: { [weak self] menuData in
                self?.process(menuData: menuData)
            })
            .disposed(by: disposeBag)

        menuRepository.outputs.openPromotion
            .subscribe(onNext: { [weak self] promotion in
                self?.openPromotion(promotionURL: promotion.url, name: promotion.name, redirectURL: self?.redirectURL ?? "")
            })
            .disposed(by: disposeBag)
    }

    private func bindScrollService() {
        scrollService.didSelectCategory
            .subscribe(onNext: { [weak self] source, category in
                guard source == .header else { return }
                self?.scroll(to: category)
            })
            .disposed(by: disposeBag)
    }

    private func process(menuData: (leadInfo: LeadInfo?,
                                    promotions: [Promotion]?,
                                    categories: [MenuCategory]?))
    {
        var tableSections = [Section]()
        process(leadInfo: menuData.leadInfo, tableSections: &tableSections)
        process(promotions: menuData.promotions, tableSections: &tableSections)
        process(categories: menuData.categories, tableSections: &tableSections)
        self.tableSections = tableSections
        configureAnimation()
        outputs.updateTableView.accept(())
    }

    private func process(leadInfo: LeadInfo?, tableSections: inout [Section]) {
        guard let leadInfo = leadInfo else { return }
        outputs.brandImage.accept(leadInfo.brandImage)
        outputs.brandName.accept(leadInfo.brandName)
        let addressViewModels = [AddressPickCellViewModel(address: leadInfo.address)]
        let section = Section(type: .address,
                              headerViewModel: nil,
                              cellViewModels: addressViewModels)
        tableSections.insert(section, at: 0)
    }

    private func process(promotions: [Promotion]?, tableSections: inout [Section]) {
        guard let promotions = promotions,
              !promotions.isEmpty else { return }

        let promotionsViewModels = [AdCollectionCellViewModel(
            promotions: promotions.sorted(by: { $0.priority < $1.priority })
        )]

        let index = (tableSections.firstIndex(where: { $0.type == .address }) ?? -1) + 1

        tableSections.insert(.init(type: .promotions,
                                   headerViewModel: nil,
                                   cellViewModels: promotionsViewModels),
                             at: index)
    }

    private func process(categories: [MenuCategory]?, tableSections: inout [Section]) {
        guard let categories = categories?.filter({ !$0.positions.isEmpty }) else { return }
        tableSections.append(
            .init(type: .positions,
                  headerViewModel: CategoriesSectionHeaderViewModel(categories: categories),
                  cellViewModels: categories
                      .map { $0.positions.map { MenuCellViewModel(position: $0) } }
                      .flatMap { $0 })
        )
    }

    func configureAnimation() {}
}

extension MenuViewModel {
    func processToBrand() {
        guard tokenStorage.token != nil else {
            outputs.toAuthChangeBrand.accept(())
            return
        }

        outputs.toChangeBrand.accept(())
    }

    func processToAddresses() {
        guard tokenStorage.token != nil else {
            outputs.toAuthChangeAddress.accept(())
            return
        }

        outputs.toAddressess.accept(())
    }

    func update() {
        menuRepository.getMenuItems()
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
            cell.setRedirectURL(with: redirectURL)
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
            processToAddresses()
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

extension MenuViewModel {
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
              tableSections[positionsIndex].cellViewModels.count > position,
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
}

extension MenuViewModel: AddCollectionCellDelegate {
    func openPromotion(promotionURL: URL, name: String, redirectURL: String) {
        outputs.toPromotion.accept((promotionURL, name, redirectURL))
    }
}

extension MenuViewModel {
    struct Output {
        let brandImage = PublishRelay<String?>()
        let brandName = PublishRelay<String?>()

        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let updateTableView = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()

        let showAnimation = PublishRelay<LottieAnimationModel>()
        let hideAnimation = PublishRelay<Void>()

        let toPromotion = PublishRelay<(URL, String, String)>()
        let toPositionDetail = PublishRelay<String>()

        let scrollToRowAt = PublishRelay<IndexPath>()

        let toChangeBrand = PublishRelay<Void>()
        let toAddressess = PublishRelay<Void>()
        let toAuthChangeBrand = PublishRelay<Void>()
        let toAuthChangeAddress = PublishRelay<Void>()
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
