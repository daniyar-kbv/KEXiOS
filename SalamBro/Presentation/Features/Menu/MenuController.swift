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

final class MenuController: ViewController {
    private let viewModel: MenuViewModelProtocol
    private let disposeBag = DisposeBag()
    var scrollService: MenuScrollService

    private lazy var logoView: UIImageView = {
        let view = UIImageView()
        view.image = Asset.Brands.salamBro4.image
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
        view.image = Asset.chevronBottom.image
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

        bindScrollService()
    }

    required init?(coder _: NSCoder) { nil }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    private func bind() {
        viewModel.updateTableView
            .bind(to: itemTableView.rx.reload)
            .disposed(by: disposeBag)

        viewModel.brandName
            .bind(to: brandLabel.rx.text)
            .disposed(by: disposeBag)
    }

    func bindScrollService() {
        scrollService.didSelectCategory
            .subscribe(onNext: { [weak self] in
                guard $0 == .header else { return }
                self?.scrollToItem(at: $1)
            })
            .disposed(by: disposeBag)
    }

    override func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .white
        [logoView, brandLabel, bottomChevronImage].forEach { brandSelectView.addSubview($0) }
        [brandSelectView, itemTableView].forEach { view.addSubview($0) }
    }

    func setupConstraints() {
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
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
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
        viewModel.selectMainInfo()
    }
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
//    TODO: change to coordinators
    public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.cellViewModels[indexPath.section][indexPath.row] {
        case _ as MenuCellViewModel:
            viewModel.coordinator.openDetail()
        case _ as AddressPickCellViewModel:
            viewModel.selectAddress()
        case _ as AdCollectionCellViewModel:
            goToRating()
        default:
            print("other")
        }
    }

    public func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.headerViewModels[section] {
        case is CategoriesSectionHeaderViewModelProtocol:
            return 44
        default:
            return 0
        }
    }

    public func numberOfSections(in _: UITableView) -> Int {
        viewModel.cellViewModels.count
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.headerViewModels[section] {
        case let viewModel as CategoriesSectionHeaderViewModelProtocol:
            let header = tableView.dequeueReusableHeaderFooterView(CategoriesSectionHeader.self)
            header?.set(viewModel)
            header?.scrollService = scrollService
            return header
        default:
            return nil
        }
    }

    public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellViewModels[section].count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.cellViewModels[indexPath.section][indexPath.row] {
        case let viewModel as AddressPickCellViewModelProtocol:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: AddressPickCell.self)
            cell.selectionStyle = .none
            cell.set(viewModel)
            return cell
        case let viewModel as AdCollectionCellViewModelProtocol:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: AdCollectionCell.self)
            cell.selectionStyle = .none
            cell.set(viewModel)
            cell.delegate = self
            return cell
        case let viewModel as MenuCellViewModelProtocol:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MenuCell.self)
            cell.selectionStyle = .none
            cell.set(viewModel)
            return cell
        default:
            return .init()
        }
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        didScrollToItem(at: indexPath.row)
    }
}

extension MenuController {
    func scrollToItem(at position: Int) {
        guard let row = viewModel.cellViewModels[itemTableView.numberOfSections - 1].enumerated().first(where: {
            guard let viewModel = $1 as? MenuCellViewModelProtocol else { return false }
            return viewModel.categoryPosition == position
        })?.0 else { return }
        itemTableView.scrollToRow(at: IndexPath(row: row, section: itemTableView.numberOfSections - 1), at: .top, animated: true)
    }

    func didScrollToItem(at position: Int) {
        guard let cellViewModel = viewModel.cellViewModels[itemTableView.numberOfSections - 1][position] as? MenuCellViewModelProtocol,
              !scrollService.isHeaderScrolling,
              scrollService.currentCategoryPosition != cellViewModel.categoryPosition else { return }
        scrollService.didSelectCategory.accept((source: .table, position: cellViewModel.categoryPosition))
    }
}

extension MenuController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_: UIScrollView) {
        scrollService.finishedScrolling()
    }
}

extension MenuController: AddCollectionCellDelegate {
//    TODO: change to coordinator
    public func goToRating() {
        viewModel.coordinator.openRating()
    }
}
