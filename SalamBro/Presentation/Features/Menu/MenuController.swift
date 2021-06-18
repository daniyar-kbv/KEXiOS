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

final class MenuController: ViewController, AlertDisplayable, LoaderDisplayable {
    let outputs = Output()

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
    }

    required init?(coder _: NSCoder) { nil }

    override public func viewDidLoad() {
        super.viewDidLoad()

        viewModel.update()

        setup()
        bindViewModel()
        bindScrollService()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    private func bindViewModel() {
        viewModel.brandName
            .bind(to: brandLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.updateTableView
            .bind(to: itemTableView.rx.reload)
            .disposed(by: disposeBag)

        viewModel.outputs.didStartRequest
            .subscribe(onNext: { [weak self] in
                print("didStartRequest showLoader")
                self?.showLoader()
            }, onError: { [weak self] error in
                print("didStartRequest error \(error)")
            }, onCompleted: {
                print("didStartRequest onCompleted")
            },
            onDisposed: {
                print("didStartRequest disposed")
            }).disposed(by: disposeBag)

        viewModel.outputs.didStartRequest
            .subscribe(onNext: <#T##((()) -> Void)?##((()) -> Void)?##(()) -> Void#>,
                       onError: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>, onCompleted: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onDisposed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)

        viewModel.outputs.didEndRequest
            .subscribe(onNext: { [weak self] in
                print("hideLoader")
                self?.hideLoader()
            }).disposed(by: disposeBag)

        viewModel.outputs.didGetError
            .subscribe(onNext: { [weak self] error in
                guard let error = error else { return }
                self?.showError(error)
            }).disposed(by: disposeBag)
    }

    func bindScrollService() {
        scrollService.didSelectCategory
            .subscribe(onNext: { [weak self] source, category in
                guard source == .header else { return }
                self?.scroll(to: category)
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
        outputs.toChangeBrand.accept { [weak self] in
            self?.viewModel.update()
        }
    }
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
//    TODO: change to coordinators
    public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.cellViewModels[indexPath.section][indexPath.row] {
        case let cellViewModel as MenuCellViewModel:
            outputs.toPositionDetail.accept(cellViewModel.position.uuid)
        case _ as AddressPickCellViewModel:
            outputs.toAddressess.accept { [weak self] in
                self?.viewModel.update()
            }
        case let cellViewModel as AdCollectionCellViewModel:
            guard let promotionURL = URL(string: cellViewModel.cellViewModels[indexPath.row].promotion.link) else { return }
            outputs.toPromotion.accept((promotionURL, nil))
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
    func scroll(to category: String) {
        guard let row = viewModel.cellViewModels[itemTableView.numberOfSections - 1]
            .enumerated().first(where: {
                guard let viewModel = $1 as? MenuCellViewModelProtocol else { return false }
                return viewModel.position.category == category
            })?.0 else { return }
        itemTableView.scrollToRow(at: IndexPath(row: row, section: itemTableView.numberOfSections - 1), at: .top, animated: true)
    }

    func didScrollToItem(at position: Int) {
        guard let cellViewModel = viewModel.cellViewModels[itemTableView.numberOfSections - 1][position] as? MenuCellViewModelProtocol,
              !scrollService.isHeaderScrolling,
              scrollService.currentCategory != cellViewModel.position.category else { return }
        scrollService.didSelectCategory.accept((source: .table, category: cellViewModel.position.category))
    }
}

extension MenuController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_: UIScrollView) {
        scrollService.finishedScrolling()
    }
}

extension MenuController: AddCollectionCellDelegate {
    public func goToRating(promotionURL: URL, infoURL: URL?) {
        outputs.toPromotion.accept((promotionURL, infoURL))
    }
}

extension MenuController {
    struct Output {
        let toPromotion = PublishRelay<(URL, URL?)>()
        let toChangeBrand = PublishRelay<() -> Void>()
        let toAddressess = PublishRelay<() -> Void>()
        let toPositionDetail = PublishRelay<String>()
    }
}
