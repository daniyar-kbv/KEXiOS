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

final class MenuController: UIViewController, LoaderDisplayable {
    let outputs = Output()

    private let viewModel: MenuViewModelProtocol
    private let disposeBag = DisposeBag()

    private lazy var logoView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 9
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

    public init(viewModel: MenuViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { nil }

    override public func viewDidLoad() {
        super.viewDidLoad()

        layoutUI()
        bindViewModel()

        viewModel.update()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)

        viewModel.configureAnimation()
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

        viewModel.outputs.showAnimation
            .subscribe(onNext: { [weak self] animationType in
                self?.itemTableView.backgroundView = self?.getAnimationView(animationType: animationType, action: nil)
            }).disposed(by: disposeBag)

        viewModel.outputs.hideAnimation
            .subscribe(onNext: { [weak self] in
                self?.itemTableView.backgroundView = nil
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

        viewModel.outputs.toPromotion
            .bind(to: outputs.toPromotion)
            .disposed(by: disposeBag)

        viewModel.outputs.toChangeBrand
            .bind(to: outputs.toChangeBrand)
            .disposed(by: disposeBag)

        viewModel.outputs.toAddressess
            .bind(to: outputs.toAddressess)
            .disposed(by: disposeBag)

        viewModel.outputs.toAuthChangeBrand
            .bind(to: outputs.toAuthChangeBrand)
            .disposed(by: disposeBag)

        viewModel.outputs.toAuthChangeAddress
            .bind(to: outputs.toAuthChangeAddress)
            .disposed(by: disposeBag)

        viewModel.outputs.toPositionDetail
            .bind(to: outputs.toPositionDetail)
            .disposed(by: disposeBag)

        viewModel.outputs.scrollToRowAt
            .subscribe(onNext: { [weak self] indexPath in
                self?.itemTableView.scrollToRow(at: indexPath, at: .top, animated: true)
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
        viewModel.processToBrand()
    }
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.heightForHeader(in: section)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewModel.viewForHeader(in: tableView, for: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(in: tableView, for: indexPath)
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.willDisplayRow(at: indexPath)
    }
}

extension MenuController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_: UIScrollView) {
        viewModel.finishedScrolling()
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
        let toChangeBrand = PublishRelay<Void>()
        let toAddressess = PublishRelay<Void>()
        let toPositionDetail = PublishRelay<String>()
        let toAuthChangeBrand = PublishRelay<Void>()
        let toAuthChangeAddress = PublishRelay<Void>()
    }
}
