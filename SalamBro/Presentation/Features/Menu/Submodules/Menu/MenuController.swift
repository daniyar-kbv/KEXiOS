//
//  MenuController.swift
//  SalamBro
//
//  Created by Arystan on 4/27/21.
//

import Reusable
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class MenuController: UIViewController, AlertDisplayable, LoaderDisplayable {
    let outputs = Output()

    private let viewModel: MenuViewModelProtocol
    private let disposeBag = DisposeBag()
    private var scrollService: MenuScrollService

    private lazy var logoView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var brandLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 20)
        return view
    }()

    private lazy var bottomChevronImage: UIImageView = {
        let view = UIImageView()
        view.image = SBImageResource.getIcon(for: MenuIcons.Menu.arrow)
        return view
    }()

    private lazy var brandSelectView: UIView = {
        let view = UIView()
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(handleChangeBrandButtonAction))
        view.addGestureRecognizer(gestureRecognizer)
        return view
    }()

    private lazy var itemTableView: UITableView = {
        let view = UITableView()
        view.separatorColor = .mildBlue
        view.backgroundColor = .white
        view.register(cellType: AddressPickCell.self)
        view.register(cellType: MenuCell.self)
        view.register(cellType: AdCollectionCell.self)
        view.register(headerFooterViewType: CategoriesSectionHeader.self)
        view.delegate = self
        view.dataSource = self
        view.showsVerticalScrollIndicator = false
        view.estimatedRowHeight = 300
        view.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        view.tableFooterView = UIView()
        view.refreshControl = refreshControl
        return view
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(handleRefreshControlerAction), for: .valueChanged)
        return view
    }()

    public init(viewModel: MenuViewModelProtocol, scrollService: MenuScrollService) {
        self.viewModel = viewModel
        self.scrollService = scrollService

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { nil }

    override public func viewDidLoad() {
        super.viewDidLoad()

        layoutUI()
        bindViewModel()
        bindScrollService()

        viewModel.update()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func bindViewModel() {
        viewModel.outputs.brandImage
            .subscribe(onNext: { [weak self] imageString in
                guard let url = URL(string: imageString ?? "") else { return }
                self?.logoView.setImage(url: url)
            }).disposed(by: disposeBag)

        viewModel.outputs.brandName
            .bind(to: brandLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.updateTableView
            .bind(to: itemTableView.rx.reload)
            .disposed(by: disposeBag)

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
                guard let error = error else { return }
                self?.showError(error)
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

    private func layoutUI() {
        view.backgroundColor = .white
        [logoView, brandLabel, bottomChevronImage].forEach { brandSelectView.addSubview($0) }
        [brandSelectView, itemTableView].forEach { view.addSubview($0) }

        logoView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 48, height: 48))
            $0.top.left.equalToSuperview()
        }

        brandLabel.snp.makeConstraints {
            $0.left.equalTo(logoView.snp.right).offset(8)
            $0.centerY.equalTo(logoView.snp.centerY)
        }

        bottomChevronImage.snp.makeConstraints {
            $0.top.equalTo(brandLabel.snp.top)
            $0.left.equalTo(brandLabel.snp.right)
            $0.height.width.equalTo(24)
        }

        brandSelectView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(8)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }

        itemTableView.snp.makeConstraints {
            $0.top.equalTo(brandSelectView.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottomMargin)
        }
    }

    @objc private func handleRefreshControlerAction(_: UIRefreshControl) {
        refreshControl.endRefreshing()
        viewModel.update()
    }

    @objc private func handleChangeBrandButtonAction(_: UIButton) {
        outputs.toChangeBrand.accept { [weak self] in
            self?.viewModel.update()
        }
    }
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.tableSections[indexPath.section].type {
        case .positions:
            guard let cellViewModel = viewModel
                .tableSections[indexPath.section]
                .cellViewModels[indexPath.row]
                as? MenuCellViewModelProtocol
            else { return }

            outputs.toPositionDetail.accept(cellViewModel.position.uuid)
        case .address:
            outputs.toAddressess.accept { [weak self] in
                self?.viewModel.update()
            }
        default:
            break
        }
    }

    public func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.tableSections[section].type {
        case .positions:
            return 44
        default:
            return 0
        }
    }

    func numberOfSections(in _: UITableView) -> Int {
        return viewModel.tableSections.count
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.tableSections[section].type {
        case .positions:
            guard let headerViewModel = viewModel.tableSections[section].headerViewModel as? CategoriesSectionHeaderViewModelProtocol
            else { return nil }
            let header = tableView.dequeueReusableHeaderFooterView(CategoriesSectionHeader.self)
            header?.set(headerViewModel)
            header?.scrollService = scrollService
            return header
        default:
            return nil
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableSections[section].cellViewModels.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard viewModel.tableSections.count > 0,
              viewModel.tableSections[indexPath.section].cellViewModels.count > 0
        else { return .init() }
        let cellViewModel = viewModel.tableSections[indexPath.section].cellViewModels[indexPath.row]
        switch viewModel.tableSections[indexPath.section].type {
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

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        didScrollToItem(at: indexPath.row)
    }
}

extension MenuController {
    private func scroll(to categoryUUID: String) {
        guard let row = viewModel
            .tableSections[itemTableView.numberOfSections - 1]
            .cellViewModels
            .enumerated()
            .first(where: {
                guard let viewModel = $1 as? MenuCellViewModelProtocol else { return false }
                return viewModel.position.categoryUUID == categoryUUID
            })?
            .0
        else { return }
        itemTableView.scrollToRow(at: IndexPath(row: row, section: itemTableView.numberOfSections - 1), at: .top, animated: true)
    }

    private func didScrollToItem(at position: Int) {
        guard viewModel.tableSections.count > 0,
              let cellViewModel = viewModel
              .tableSections[itemTableView.numberOfSections - 1]
              .cellViewModels[position]
              as? MenuCellViewModelProtocol,
              !scrollService.isHeaderScrolling,
              scrollService.currentCategory != cellViewModel.position.categoryUUID else { return }
        scrollService.didSelectCategory.accept((source: .table, categoryUUID: cellViewModel.position.categoryUUID))
    }
}

extension MenuController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_: UIScrollView) {
        scrollService.finishedScrolling()
    }
}

extension MenuController: AddCollectionCellDelegate {
    public func goToRating(promotionURL: URL, name: String) {
        outputs.toPromotion.accept((promotionURL, name))
    }
}

extension MenuController: Reloadable {
    func reload() {
        viewModel.update()
    }
}

extension MenuController {
    struct Output {
        let toPromotion = PublishRelay<(URL, String)>()
        let toChangeBrand = PublishRelay<() -> Void>()
        let toAddressess = PublishRelay<() -> Void>()
        let toPositionDetail = PublishRelay<String>()
    }
}
